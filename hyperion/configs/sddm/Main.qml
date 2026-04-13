import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080

    // Background image
    Image {
        id: background
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    // Dark overlay for better text readability
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.3
    }

    // Login panel
    Rectangle {
        id: loginPanel
        width: 400
        height: 300
        anchors.centerIn: parent
        color: "#1a1a1a"
        opacity: 0.85
        radius: 10

        Column {
            anchors.centerIn: parent
            spacing: 20
            width: parent.width - 60

            // Welcome text
            Text {
                text: "Welcome to Hyperion"
                color: "white"
                font.pixelSize: 24
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Username field
            TextField {
                id: usernameField
                width: parent.width
                placeholderText: "Username"
                color: "white"
                font.pixelSize: 14
                text: userModel.lastUser
                background: Rectangle {
                    color: "#2a2a2a"
                    radius: 5
                    border.color: usernameField.activeFocus ? "#7f7fff" : "#3a3a3a"
                    border.width: 2
                }
                KeyNavigation.tab: passwordField
                Keys.onReturnPressed: passwordField.forceActiveFocus()
            }

            // Password field
            TextField {
                id: passwordField
                width: parent.width
                placeholderText: "Password"
                echoMode: TextInput.Password
                color: "white"
                font.pixelSize: 14
                background: Rectangle {
                    color: "#2a2a2a"
                    radius: 5
                    border.color: passwordField.activeFocus ? "#7f7fff" : "#3a3a3a"
                    border.width: 2
                }
                KeyNavigation.tab: loginButton
                Keys.onReturnPressed: sddm.login(usernameField.text, passwordField.text, sessionCombo.currentIndex)
                onAccepted: sddm.login(usernameField.text, passwordField.text, sessionCombo.currentIndex)
            }

            // Session selector
            ComboBox {
                id: sessionCombo
                width: parent.width
                model: sessionModel
                textRole: "name"
                currentIndex: sessionModel.lastIndex
                font.pixelSize: 14
                background: Rectangle {
                    color: "#2a2a2a"
                    radius: 5
                    border.color: sessionCombo.activeFocus ? "#7f7fff" : "#3a3a3a"
                    border.width: 2
                }
                contentItem: Text {
                    text: sessionCombo.displayText
                    color: "white"
                    font: sessionCombo.font
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 10
                }
            }

            // Login button
            Button {
                id: loginButton
                width: parent.width
                height: 40
                text: "Login"
                font.pixelSize: 14

                background: Rectangle {
                    color: loginButton.down ? "#6f6fef" : "#7f7fff"
                    radius: 5
                }

                contentItem: Text {
                    text: loginButton.text
                    font: loginButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: sddm.login(usernameField.text, passwordField.text, sessionCombo.currentIndex)
            }
        }
    }

    // Power buttons in bottom right
    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 15

        Button {
            text: "Reboot"
            width: 80
            height: 35
            onClicked: sddm.reboot()
            background: Rectangle {
                color: parent.down ? "#5a5a5a" : "#4a4a4a"
                radius: 5
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Button {
            text: "Shutdown"
            width: 80
            height: 35
            onClicked: sddm.powerOff()
            background: Rectangle {
                color: parent.down ? "#5a5a5a" : "#4a4a4a"
                radius: 5
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Component.onCompleted: {
        if (usernameField.text === "") {
            usernameField.forceActiveFocus()
        } else {
            passwordField.forceActiveFocus()
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            passwordField.text = ""
            passwordField.forceActiveFocus()
        }
    }
}
