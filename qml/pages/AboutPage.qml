/*
 * This file is part of harbour-todolist.
 * SPDX-FileCopyrightText: 2020-2024 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

/*
 * Translators:
 * Please add yourself to the list of translators in TRANSLATORS.json.
 * If your language is already in the list, add your name to the 'entries'
 * field. If you added a new translation, create a new section in the 'extra' list.
 *
 * Other contributors:
 * Please add yourself to the relevant list of contributors below.
 *
*/

import QtQuick 2.0
import Sailfish.Silica 1.0 as S
import Opal.About 1.0 as A

A.AboutPageBase {
    id: page

    appName: main.appName
    appIcon: Qt.resolvedUrl("../images/harbour-todolist.png")
    appVersion: APP_VERSION
    appRelease: APP_RELEASE

    allowDownloadingLicenses: false
    sourcesUrl: "https://github.com/Smooth-E/aurora-todolist"
    changelogList: Qt.resolvedUrl("../Changelog.qml")
    licenses: A.License { spdxId: "GPL-3.0-or-later" }

    donations.text: qsTr("If you found this app helpful, feel welcome to support the original "
                         + "developer or the Aurora OS port maintainer by donating.")

    donations.services: [
        A.DonationService {
            name: qsTr("App dev's Liberapay")
            url: "https://liberapay.com/ichthyosaurus"
        },
        A.DonationService {
            name: qsTr("Port maintainer's Boosty")
            url: "https://boosty.to/smooth-e/donate"
        }
    ]

    description: qsTr("A simple tool for planning what to do next.")
    mainAttributions: [ "2025 Smooth-E", "2020-%1 Mirian Margiani".arg((new Date()).getFullYear()) ]
    autoAddOpalAttributions: true

    attributions: [
        A.Attribution {
            name: "SortFilterProxyModel"
            entries: ["2016 Pierre-Yves Siret"]
            licenses: A.License { spdxId: "MIT" }
            sources: "https://github.com/oKcerG/SortFilterProxyModel"
        }
    ]

    contributionSections: [
        A.ContributionSection {
            title: qsTr("Development")
            groups: [
                A.ContributionGroup {
                    title: qsTr("Programming")
                    entries: ["Mirian Margiani", "Johannes Bachmann", "Øystein S. Haaland"]
                },
                A.ContributionGroup {
                    title: qsTr("Aurora OS Port")
                    entries: [ "Smooth-E" ]
                }
            ]
        },
        //>>> GENERATED LIST OF TRANSLATION CREDITS
        A.ContributionSection {
            title: qsTr("Translations")
            groups: [
                A.ContributionGroup {
                    title: qsTr("Swedish")
                    entries: [
                        "Åke Engelbrektson"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Spanish")
                    entries: [
                        "Kamborio",
                        "gallegonovato"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Russian")
                    entries: [
                        "Nikolay Sinyov"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Polish")
                    entries: [
                        "atlochowski",
                        "likot180"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Norwegian Nynorsk")
                    entries: [
                        "Øystein S. Haaland"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Indonesian")
                    entries: [
                        "Reza Almanda"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("German")
                    entries: [
                        "Mirian Margiani"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Estonian")
                    entries: [
                        "Priit Jõerüüt"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("English")
                    entries: [
                        "Mirian Margiani"
                    ]
                },
                A.ContributionGroup {
                    title: qsTr("Chinese")
                    entries: [
                        "dashinfantry"
                    ]
                }
            ]
        }
        //<<< GENERATED LIST OF TRANSLATION CREDITS
    ]

    S.PullDownMenu {
        parent: page.flickable

        /*S.MenuItem {
            text: qsTr("Import from other apps")
            onClicked: console.warn("not yet implemented")
        }
        S.MenuItem {
            text: qsTr("Export data")
            onClicked: console.warn("not yet implemented")
        }*/

        S.MenuItem {
            text: qsTr("View old entries")
            onClicked: pageStack.animatorPush(Qt.resolvedUrl("ArchivePage.qml"))
        }
    }
}
