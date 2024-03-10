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

import QtMultimedia
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

import "../js/scripts.js" as Js

PlasmoidItem {
    id: main

    Layout.minimumHeight: Kirigami.Units.gridUnit * 12
    Layout.minimumWidth: Kirigami.Units.gridUnit * 12
    Layout.preferredHeight: Kirigami.Units.gridUnit * 20
    Layout.preferredWidth: Kirigami.Units.gridUnit * 20

    switchWidth: Kirigami.Units.gridUnit * 12
    switchHeight: Kirigami.Units.gridUnit * 12

    toolTipMainText: i18n("Volume") + ": " + plasmoid.configuration.globalVolume + " %"
    toolTipSubText: playing ? i18np("Playing 1 noise", "Playing %1 noises", noiseComponentsModel.count) : i18n("Paused")

    Plasmoid.icon: "ambientnoise"

    property real maxVolume: 100.0
    property real minVolume:   0.0
    property real volumeStep:  5.0

    property bool playing: plasmoid.configuration.playing // Do not bind this to pausedAtStartup

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Play")
            icon.name: "media-playback-start"
            priority: Plasmoid.LowPriorityAction
            visible: !playing
            enabled: !playing
            onTriggered: action_playpause()
        },
        PlasmaCore.Action {
            text: i18n("Pause")
            icon.name: "media-playback-pause"
            priority: Plasmoid.LowPriorityAction
            visible: playing
            enabled: playing
            onTriggered: action_playpause()
        }
    ]

    ListModel {
        id: noiseComponentsModel
        Component.onCompleted: Js.restoreComponents()
    }

    ListView {
        id: players
        model: noiseComponentsModel

        // Nonzero size to allow fitting more than one element
        width: 1
        height: 1

        delegate: Item {
            id: player_delegate
            readonly property real volume: _volume
            readonly property bool muted: _muted
            readonly property bool playing: main.playing

            onPlayingChanged: {
                if (playing) {
                    media_player.play();
                }
                else {
                    media_player.pause();
                }
            }

            MediaPlayer {
                id: media_player
                source: Js.toAudioName(_filename)
                audioOutput: AudioOutput {
                    volume: Js.computeVolume(!player_delegate.muted * player_delegate.volume)
                }
                loops: MediaPlayer.Infinite
            }
        }
    }

    function action_playpause() {
        playing = !playing;
        plasmoid.configuration.playing = playing;
    }

    Component.onCompleted: {
        playing = playing && !plasmoid.configuration.pausedAtStartup;
    }

    compactRepresentation: Kirigami.Icon {
        property PlasmoidItem plasmoidItem

        source: plasmoid.icon
        active: mouseArea.containsMouse

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton

            onClicked: function (mouse) {
                if (mouse.button == Qt.MiddleButton) {
                    action_playpause();
                } else if (mouse.button == Qt.LeftButton) {
                    plasmoidItem.expanded = !plasmoidItem.expanded;
                }
            }

            onWheel: function (wheel) {
                var angleStep = 45;
                var volumeDelta = main.volumeStep * Math.round(wheel.angleDelta.y / angleStep);
                var volume = plasmoid.configuration.globalVolume + volumeDelta;
                plasmoid.configuration.globalVolume = Math.min(main.maxVolume, Math.max(main.minVolume, volume))
            }
        }
    }

    fullRepresentation: StackView {
        id: stack
        initialItem: ColumnLayout {
            // Global controls
            RowLayout {

                id: globalControls
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                // Add new noise component
                PlasmaComponents.ToolButton {
                    id: addButton
                    icon.name: "list-add"
                    ToolTip.text: i18n("Add a noise component")
                    ToolTip.visible: hovered
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        stack.push("AddNoisePopup.qml");
                    }
                }

                // Play/Pause
                PlasmaComponents.ToolButton {
                    id: playButton
                    icon.name: playing ? "media-playback-pause" : "media-playback-start"
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
                    from: main.minVolume
                    to: main.maxVolume
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
                        imageSource: Js.toImageName(_filename)
                        noiseName: Js.toPrettyName(_filename)
                        volume: _volume
                        muted: _muted
                    }
                }
            }
        }
    }
}
