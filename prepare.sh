#!/bin/bash

# SPDX-FileCopyrightText: 2025-2026 Smooth-E
# SPDX-License-Identifier: GPL-3.0-or-later

# Example project used as reference:
# https://gitlab.com/omprussia/python/PySideWithSystemQt/-/blob/c25aa8da4c280246f5ea1f5959a3344ec889a1ff/build_python3.sh

target=""
arch=""
cpython_version=3.14

# Select certain build steps with command line args
select_all=1
select_cpython=
select_clean_cpython=
select_pyotherside=

cpython_enable_optimizations="--enable-optimizations"

help()
{
   # Display Help
   echo "Syntax: prepare REQUIRED [SELECTIVE] [EXTRA]"
   echo "Required options (specify one of):"
   echo "  -t   Set the target to build. Example: AuroraOS-5.1.1.60-base-armv7hl."
   echo "  -h   Print this help."
   echo "Selective build. If at least one is specified, only selected build steps will be performed."
   echo "  --build-cpython     Build cpython."
   echo "  --clean-cpython     Remove unnecessary cpython components to optimize build time and app size."
   echo "  --build-pyotherside Build pyotherside."
   echo "Extra options:"
   echo "  --enable-optimizations Pass --enable-optimizations to ./configure when building cpython for aarch64/x86_64."
}

init_target_vars()
{
	# Initialize the $arch variable from target name
	arch=$(echo ${target##*-})

	if [ "$arch" = "armv7hl" ]; then
        # Cmake defines the architecture of target AuroraOS-5.1.1.60-base-armv7hl as armv7l.
	    # Need to rename it for the correct project building
		arch="armv7l"
        # Tests fail when building cpython with --enable-optimizations in Aurora Platform SDK 5.1.5.105 for armv7hl
        cpython_enable_optimizations=""
	fi
}

install_dependencies()
{
	sb2 -t $target -R zypper install -y libopenssl-devel \
	libxml2-devel libxslt-devel qt5-qtprintsupport-devel \
	qt5-qttools-qtdesigner qt5-qttools-qtdesigner-devel \
	qt5-qttools-qtuitools-devel libqtwebkit5-widgets-devel \
	qt5-qtscript-devel qt5-qttools-qthelp-devel \
	qt5-qtwebsockets-devel qt5-qttest-devel \
	qt5-qttools-qtuiplugin-devel sqlite-devel || exit 1
}

build_cpython()
{
    echo Building cpython...

    # Create output directory
    mkdir -p vendor/$arch

    # Someone refers to this as 'shadow' build
    cd libs/cpython
    mkdir -p build
    cd build

    # Obtain build flags
    build_flags=$(sb2 -t $target rpm --eval '%set_build_flags')
    echo Obtained build flags: $build_flags

    # Build cpython with mb2
    sb2 -t $target bash -c "$build_flags && \
	  ../configure --prefix=$(pwd)/../../../vendor/$arch --enable-shared $cpython_enable_optimizations && \
	  make -j$(nproc --all) && \
	  make install || exit 1"

      # Return to project root
      cd ../../../
}

clean_cpython()
{
    echo Removing unneeded cpython modules

    # Remove unneeded modules
    rm -r $(pwd)/vendor/$arch/lib/python$cpython_version/test/
    rm -r $(pwd)/vendor/$arch/lib/python$cpython_version/idlelib/ 
    rm -r $(pwd)/vendor/$arch/lib/python$cpython_version/venv
    rm -r $(pwd)/vendor/$arch/lib/python$cpython_version/unittest/
    rm -r $(pwd)/vendor/$arch/lib/python$cpython_version/turtle.py 
    rm -r $(pwd)/vendor/$arch/lib/python$cpython_version/turtledemo/
    rm -r $(pwd)/vendor/$arch/lib/python$cpython_version/tkinter/
}

build_pyotherside()
{
    echo Building pyotherside...

    mkdir -p vendor/$arch
    
    cd libs/pyotherside
    mkdir -p build
    cd build

    build_flags=$(sb2 -t $target rpm --eval '%set_build_flags')

    sb2 -t $target bash -c " \
        echo Building pyotherside: build_flags... && \
        $build_flags && \
        echo Building pyotherside: qmake... && \
        qmake PREFIX=$(pwd)/../../../vendor/$arch/ \
              INCLUDEPATH+=$(pwd)/../../../vendor/$arch/include/python$cpython_version/ \
              LIBS+=-L$(pwd)/../../../vendor/$arch/lib/ .. && \
        echo Building pyotherside: make... && \
        PATH=$(pwd)/../../../vendor/$arch/bin/:$PATH make -j$(nproc --all) && \
        echo Building pyotherside: make install... && \
        make INSTALL_ROOT=$(pwd)/../../../vendor/$arch/ install || exit 1"

    # Return to project root
    cd ../../../
}

clear_build_folders()
{
	echo "Clear build folders..."

    # Remove build dirs
    cd libs
	rm -rf cpython/build
    rm -rf pyotherside/build
    cd ..

    # Remove pycache folders
	cd vendor
	find . -type d -name __pycache__ -exec rm -r {} +

    # Return to project root
	cd ..
}

if [[ $# = 0 ]];
then 
	help;
    exit 0;
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        (-t)
            echo Target is \"$2\"
            target="$2"
            shift
            shift
        ;;
        (--build-cpython)
            select_cpython=1
            select_clean_cpython=1
            select_all=0
            shift
        ;;
        (--clean-cpython)
            select_clean_cpython=1
            select_all=0
            shift
        ;;
        (--build-pyotherside)
            select_pyotherside=1
            select_all=0
            shift
        ;;
        (--enable-optimizations)
            cpython_enable_optimizations="--enable-optimizations"
            shift
        ;;
        (-h)
            help
            exit 0
        ;;
        (*)
            echo Unsupported argument: $1
            echo
            help
            exit 1
        ;;
    esac
done

init_target_vars
install_dependencies
if (( select_all || select_cpython )); then build_cpython; fi
if (( select_all || select_clean_cpython )); then clean_cpython; fi
if (( select_all || select_pyotherside )); then build_pyotherside; fi
clear_build_folders
