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
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras

import "../js/scripts.js" as Js

PlasmaExtras.ListItem {
    id: root
    width: .95 * noiseComponents.width
    height: Kirigami.Units.gridUnit * 4
    separatorVisible: false

    property alias noiseName: name.text
    property alias imageSource: componentIcon.source
    property alias volume: slider.value
    property bool muted: false

    Component.onCompleted: Js.saveComponents()

    RowLayout {
        id: componentLine
        width: root.width
        spacing: Kirigami.Units.smallSpacing

        // Image for the noise component
        Image {
            id: componentIcon
            Layout.fillHeight: true
            Layout.preferredWidth: height
            fillMode: Image.PreserveAspectFit
        }

        ColumnLayout {
            id: leftColumn
            Layout.fillWidth: true

            // Name
            Label {
                id: name
                Layout.alignment: Qt.AlignLeft
            }

            // Component controls
            RowLayout {
                id: controlsRow
                width: leftColumn.width
                spacing: Kirigami.Units.smallSpacing
                Layout.alignment: Qt.AlignCenter

                // Delete component
                PlasmaComponents.ToolButton {
                    id: deleteButton
                    icon.name: "edit-delete"
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        noiseComponentsModel.remove(index);
                        Js.saveComponents();
                    }
                }

                // Mute component
                PlasmaComponents.ToolButton {
                    id: muteButton
                    icon.name: Js.volumeIcon(slider.value, muted)
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        muted = !muted;
                        noiseComponentsModel.get(index)._muted = muted
                        Js.saveComponents();
                    }
                }

                // Volume slider for this component
                PlasmaComponents.Slider {
                    id: slider
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    from: main.minVolume
                    to: main.maxVolume
                    stepSize: main.volumeStep
                    enabled: !muted
                    opacity: muted ? 0.5 : 1.0
                    onValueChanged: {
                        noiseComponentsModel.get(index)._volume = value;
                        Js.saveComponents();
                    }
                }

                // Display volume value
                Label {
                    id: volumeLabel
                    text: slider.value + "%"
                    opacity: muted ? 0.5 : 1.0
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
    }
}
