import "components"

import QtQuick 2.0
import QtQuick.Layouts 1.2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtQuick.Controls.Styles 1.4

SessionManagementScreen {

    property bool showUsernamePrompt: !showUserList

    property string lastUserName

    //the y position that should be ensured visible when the on screen keyboard is visible
    property int visibleBoundary: mapFromItem(loginButton, 0, 0).y
    //onHeightChanged: visibleBoundary = mapFromItem(loginButton, 0, 0).y + loginButton.height + units.smallSpacing

    signal loginRequest(string username, string password)

    onShowUsernamePromptChanged: {
        if (!showUsernamePrompt) {
            lastUserName = ""
        }
    }

    /*
    * Login has been requested with the following username and password
    * If username field is visible, it will be taken from that, otherwise from the "name" property of the currentIndex
    */
    function startLogin() {
        var username = showUsernamePrompt ? userNameInput.text : userList.selectedUser
        var password = passwordBox.text

        //this is partly because it looks nicer
        //but more importantly it works round a Qt bug that can trigger if the app is closed with a TextField focussed
        //DAVE REPORT THE FRICKING THING AND PUT A LINK
        loginButton.forceActiveFocus();
        loginRequest(username, password);
    }

    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter
        Layout.leftMargin: 25
        spacing: 6
  
        PlasmaComponents.TextField {
            id: userNameInput
            Layout.fillWidth: true
            text: lastUserName
            visible: showUsernamePrompt
            focus: showUsernamePrompt && !lastUserName //if there's a username prompt it gets focus first, otherwise password does
            placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Username")
            horizontalAlignment: TextInput.Center
            onAccepted: passwordBox.forceActiveFocus()
        }

        RowLayout{
            //<> anchors.horizontalCenter: parent.horizontalCenter
            Layout.alignment: Qt.AlignHCenter
            
            PlasmaComponents.TextField {
                id: passwordBox
                Layout.fillWidth: true
                width: Layout.width * 2
                placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Password")
                focus: !showUsernamePrompt || lastUserName
                echoMode: TextInput.Password
                revealPasswordButtonShown: true
                horizontalAlignment: TextInput.Center
                LayoutMirroring.enabled: true
                onAccepted: startLogin()
                textColor: "#111111"
                Keys.onEscapePressed: {
                    mainStack.currentItem.forceActiveFocus();
                }

                //if empty and left or right is pressed change selection in user switch
                //this cannot be in keys.onLeftPressed as then it doesn't reach the password box
                Keys.onPressed: {
                    if (event.key == Qt.Key_Left && !text) {
                        userList.decrementCurrentIndex();
                        event.accepted = true
                    }
                    if (event.key == Qt.Key_Right && !text) {
                        userList.incrementCurrentIndex();
                        event.accepted = true
                    }
                }

                Connections {
                    target: sddm
                    onLoginFailed: {
                        passwordBox.selectAll()
                        passwordBox.forceActiveFocus()
                    }
                }

                style: TextFieldStyle {
                    background: Rectangle {
                        radius: 8
                        color: "#f1f1f1"
                        opacity: 0.7
                    }
                }

            }
            
        Rectangle{
            implicitWidth:  30
            implicitHeight: parent.height
            color: "transparent"
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                id: loginButton
                source: "components/artwork/go.svgz"
                sourceSize: Qt.size(passwordBox.height, passwordBox.height)
                smooth: true          
                opacity: 0.7 
            }
            MouseArea {
                    anchors.fill: parent
                    onClicked: startLogin();
                }
            }
        }
    }
}
