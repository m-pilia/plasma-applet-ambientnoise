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

import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtMultimedia 5.7
import org.kde.plasma.components 2.0 as PlasmaComponents
import "../js/scripts.js" as Js

PlasmaComponents.ListItem {
    id: root
    width: .95 * noiseComponents.width
    height: units.gridUnit * 4
    separatorVisible: true

    property alias noiseName: name.text
    property alias audioSource: player.source
    property alias imageSource: componentIcon.source
    property alias volume: slider.value
    property bool muted: false
    property bool playing: false

    onPlayingChanged: {
        if (playing) {
            player.play();
        } else {
            player.pause();
        }
    }

    Component.onCompleted: Js.saveComponents()

    RowLayout {
        id: componentLine
        width: root.width
        spacing: units.smallSpacing

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
                spacing: units.smallSpacing
                Layout.alignment: Qt.AlignCenter

                // Delete component
                PlasmaComponents.ToolButton {
                    id: deleteButton
                    iconName: "edit-delete"
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        noiseComponentsModel.remove(index);
                        Js.saveComponents();
                    }
                }

                // Mute component
                PlasmaComponents.ToolButton {
                    id: muteButton
                    iconName: Js.volumeIcon(slider.value, muted)
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
                    maximumValue: main.maxVolume
                    minimumValue: main.minVolume
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

    Audio {
        id: player
        loops: Audio.Infinite
        volume: muted ? 0.0 : Js.computeVolume(slider.value)
        autoPlay: root.playing
    }
}
