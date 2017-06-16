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
import Qt.labs.folderlistmodel 2.1
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import "../js/scripts.js" as Js

Popup {
    id: popup
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    ColumnLayout {
        anchors.fill: parent

        ScrollView {
            id: scrollableArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: fileList
                width: scrollableArea.width
                height: scrollableArea.height

                model: folderModel
                delegate: fileDelegate

                FolderListModel {
                    id: folderModel
                    folder: Js.dataDirectory()
                    nameFilters: ["*.ogg", "*.flac", "*.mp3", "*.wav"]
                    showDirs: false
                }

                Component {
                    id: fileDelegate
                    PlasmaComponents.ListItem {
                        separatorVisible: true

                        RowLayout {

                            Image {
                                source: Js.toImageName(fileName)
                                height: units.iconSizes.small
                                width: units.iconSizes.small
                                fillMode: Image.PreserveAspectFit
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                id: fileText
                                text: Js.toPrettyName(fileName)
                                Layout.alignment: Qt.AlignVCenter
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    componentsModel.append({
                                        "filename": fileName,
                                        "tag": componentsModel.nextAdd
                                    });
                                    popup.close();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
