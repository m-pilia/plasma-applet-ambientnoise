/*
 * This file is part of Ambient Noise.
 * Copyright (C) Martino Pilia <martino.pilia@gmail.com>, 2017
 *
 * Ambient Noise is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Ambient Noise is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Ambient Noise. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents

Item {
    id: settings
    Layout.fillWidth: true

    property string defaultNoiseDataDirectory: "/usr/share/anoise/sounds"
    property alias cfg_noiseDataDirectory: noiseData.text
    property alias cfg_pausedAtStartup: pausedAtStartup.checked

    ColumnLayout {
        width: settings.width

        /* path for noise data */
        RowLayout {
            PlasmaComponents.Label {
                text: i18n("Noise data folder") + ": "
            }

            /* drop menu */
            TextField {
                id: noiseData
                text: defaultNoiseDataDirectory
                Layout.fillWidth: true
            }

            /* restore default */
            PlasmaComponents.Button {
                icon.name: "edit-undo"
                ToolTip.text: i18n("Restore default")
                ToolTip.visible: hovered
                onClicked: {
                    noiseData.text = defaultNoiseDataDirectory
                }
            }
        }

        /* play on startup */
        PlasmaComponents.CheckBox {
            id: pausedAtStartup
            text: i18n("Paused at start-up")
        }
    }
}
