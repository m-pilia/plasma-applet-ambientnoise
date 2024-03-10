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

import Qt.labs.folderlistmodel
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid

import "../js/scripts.js" as Js

ScrollView {
    ListView {
        header: PlasmaComponents.ToolButton {
            icon.name: "draw-arrow-back"
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                stack.pop();
            }
        }

        model: FolderListModel {
            id: folderModel
            folder: Js.dataDirectory()
            nameFilters: ["*.ogg", "*.flac", "*.mp3", "*.wav"]
            showDirs: false
        }

        delegate: PlasmaExtras.ListItem {
            width: row_layout.width
            height: row_layout.height
            separatorVisible: false

            MouseArea {
                width: childrenRect.width
                height: childrenRect.height
                acceptedButtons: Qt.LeftButton

                onClicked: {
                    noiseComponentsModel.append({
                        "_filename": fileName,
                        "_volume": main.maxVolume,
                        "_muted": false,
                    });
                    if (!main.playing) {
                        main.action_playpause();
                    }
                    stack.pop();
                }

                RowLayout {
                    id: row_layout

                    Image {
                        source: Js.toImageName(fileName)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                        Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                        Layout.alignment: Qt.AlignVCenter
                    }

                    PlasmaComponents.Label {
                        id: fileText
                        text: Js.toPrettyName(fileName)
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }
        }
    }
}
