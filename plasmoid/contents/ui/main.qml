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

import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import "../js/scripts.js" as Js

Item {
    id: main

    Layout.minimumHeight: units.gridUnit * 12
    Layout.minimumWidth: units.gridUnit * 12
    Layout.preferredHeight: units.gridUnit * 20
    Layout.preferredWidth: units.gridUnit * 20

    Plasmoid.switchWidth: units.gridUnit * 12
    Plasmoid.switchHeight: units.gridUnit * 12

    Plasmoid.toolTipMainText: i18n("Ambient noise")
    Plasmoid.toolTipSubText: playing ? i18n("Playing %1 elements", noiseComponentsModel.count) : i18n("Paused")

    Plasmoid.icon: "ambientnoise"

    property real maxVolume: 100.0
    property real minVolume:   0.0
    property real volumeStep:  5.

    property bool playing: true

    ListModel {
        id: noiseComponentsModel
    }

    function action_playpause() {
        playing = !playing
    }

    Component.onCompleted: {
        plasmoid.setAction("playpause", i18n("Play/Pause"), "media-playback-start");
    }

    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
        source: plasmoid.icon
        active: mouseArea.containsMouse

        //TODO: add volume on wheel?
        MouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            onClicked: {
                if (mouse.button == Qt.MiddleButton) {
                    action_playpause()
                } else if (mouse.button == Qt.LeftButton) {
                    plasmoid.expanded = !plasmoid.expanded;
                }
            }
        }
    }

    Plasmoid.fullRepresentation: StackView {
        id: stack
        initialItem: ColumnLayout {
            // Global controls
            RowLayout {

                id: globalControls
                Layout.fillWidth: true
                spacing: units.smallSpacing

                // Add new noise component
                PlasmaComponents.ToolButton {
                    id: addButton
                    iconName: "list-add"
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        stack.push("AddNoisePopup.qml");
                    }
                }

                // Play/Pause
                PlasmaComponents.ToolButton {
                    id: playButton
                    iconName: playing ? "media-playback-pause" : "media-playback-start"
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        action_playpause();
                    }
                }

                // Global volume
                PlasmaComponents.Slider {
                    id: globalVolumeSlider
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    maximumValue: main.maxVolume
                    minimumValue: main.minVolume
                    stepSize: main.volumeStep
                    value: plasmoid.configuration.globalVolume
                    onValueChanged: {
                        plasmoid.configuration.globalVolume = value;
                    }
                }

                Label {
                    id: globalVolumeSliderLabel
                    Layout.alignment: Qt.AlignVCenter
                    text: globalVolumeSlider.value + "%"
                }
            }

            // List of noise components
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: noiseComponents

                    model: noiseComponentsModel

                    delegate: NoiseListItem {
                        playing: main.playing
                        audioSource: Js.toAudioName(filename)
                        imageSource: Js.toImageName(filename)
                        noiseName: Js.toPrettyName(filename)
                    }
                }
            }
        }
    }
}
