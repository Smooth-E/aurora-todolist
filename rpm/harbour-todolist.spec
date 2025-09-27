# This file is part of Todolist
# SPDX-FileCopyrightText: 2025 Smooth-E
# SPDX-License-Identifier: GPL-3.0-or-later

Name:       moe.smoothie.todolist

# >> macros
# << macros
%define __provides_exclude_from ^%{_datadir}/.*$
%define __requires_exclude (libpython3*|libpyside2*|libcrypt.*|libffi.*|python3dist|lib.*)

%define _buildhost Aurora Build Engine

Summary:        A simple todo list manager
Version:        2.0.0
Release:        1
Group:          Applications/Productivity
License:        GPL-3.0-or-later
URL:            https://github.com/Smooth-E/aurora-todolist
Source0:        %{name}-%{version}.tar.bz2
Requires:       sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(auroraapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
A simple to-do list manager with support for multiple projects.


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5  \
    VERSION=%{version} \
    RELEASE=%{release}

make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_libexecdir}/%{name}
%defattr(644,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
# >> files
# << files
