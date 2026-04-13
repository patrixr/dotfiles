/*
 *   Copyright 2014 David Edmundson <davidedmundson@kde.org>
 *   Copyright 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtGraphicalEffects 1.0

Item {
    id: wrapper

    property bool isCurrent: true

    readonly property var m: model
    property string name
    property string userName
    property string avatarPath
    property string iconSource
    property string idx
    property bool constrainText: true
    signal clicked()

    property real faceSize: Math.min(width, height - usernameDelegate.height - units.largeSpacing) * config.factorSizeAvatar

    opacity: isCurrent ? 1.0 : 0.5
    property bool v_playing: isCurrent ? false : true
    property string shape: "artwork/"+config.shape+".png"


    Behavior on opacity {
        OpacityAnimator {
            duration: units.longDuration
        }
    }
    
    Rectangle {
        id: boxLabel
        color: "transparent"
        width: parent.width
        height: 25
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        PlasmaComponents.Label {
            id: usernameDelegate
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            height: implicitHeight // work around stupid bug in Plasma Components that sets the height
            width: constrainText ? parent.width : implicitWidth
            text: wrapper.name
            
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            //make an indication that this has active focus, this only happens when reached with keyboard navigation
            font.underline: wrapper.activeFocus
            font.capitalization: Font.Capitalize
            font.pointSize: 13
        }

        DropShadow {
            anchors.fill: usernameDelegate
            source: usernameDelegate
            verticalOffset: 2
            color: "#000000"
            radius: 3
            samples: 6
        }
    }

    Rectangle {
        id: imageSource
        width: faceSize
        height: faceSize
        border.width:0
        radius: config.shape == "circle" ? width*0.5 : 0;
        color:  config.avatarTransparent == "true" ? "transparent" : config.avatarColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: boxLabel.top
        anchors.bottomMargin: units.smallSpacing * 5
        clip: true;

        AnimatedImage {
            id: face
            source: "artwork/gifs/"+userName+".gif"
            paused: isCurrent ? false : true;
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: faceSize - 2
            height: faceSize  - 2
            smooth: true
            visible: false
        }

        AnimatedImage {
            id: faceIcon
            source: name != "Another user" ? "artwork/gifs/"+idx+".gif" : "artwork/gifs/13.gif";
            smooth: true
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            paused:  isCurrent ? false : true;
            width: faceSize 
            height: faceSize  
        }

        Image {
            id: mask
            source: shape
            sourceSize: Qt.size(parent.width, parent.height)
            smooth: true
            visible: false
        }

        OpacityMask {
            anchors.fill: face
            source: (face.status == Image.Error || face.status == Image.Null) ? faceIcon : face;
            maskSource: mask
            cached: false
            visible:true
        }

        
        state: isCurrent ?"active":"inactive"

        states: [
            State {
                name: "active"
                PropertyChanges {
                    target: imageSource
                    opacity: 1
                }
            },
            State {
                name: "inactive"
                PropertyChanges {
                    target: imageSource
                    opacity: 0.8
                }
            }
        ]
        transitions: [
            Transition {
                from: "inactive"
                to: "active"
                SequentialAnimation {
                    PauseAnimation { duration: 250 }
                    ParallelAnimation {
                        ScaleAnimator {
                            target: imageSource
                            from: 0.9
                            to: 1.2
                            easing.type: Easing.OutQuart;
                            duration: 500
                        }
                        NumberAnimation {
                            target: imageSource
                            property: "opacity"
                            duration: 500
                            easing.type: Easing.OutQuart
                        }
                    }
                }
            },
            Transition {
                from: "active"
                to: "inactive"
                SequentialAnimation {
                    ParallelAnimation {
                        ScaleAnimator {
                            target: imageSource
                            from: 1.2
                            to: 0.9
                            easing.type: Easing.OutQuart;
                            duration: 500
                        }
                        NumberAnimation {
                            target: imageSource;
                            property: "opacity";
                            easing.type: Easing.OutQuart;
                            duration: 500;
                        }
                    }
                }
            }
        ]
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: wrapper.clicked();
    }

    Accessible.name: name
    Accessible.role: Accessible.Button
    function accessiblePressAction() {
        wrapper.clicked()
    }
}
