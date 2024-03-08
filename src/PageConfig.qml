import QtCore
import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.1

GroupBox {
    title: Qt.application.displayName

    property alias webPageZoomVal : webPageZoom.realValue
    property alias sUrl: urlText.text
    property alias reloadTimeout : reloadSpinBox.value

    signal closeApp()
    signal reloadUrl()
    signal minimizeApp()
    signal showBrowser()

    Component.onDestruction: {
        console.log("Saving config.");
        settings.url = urlText.text
        settings.reloadVal = reloadSpinBox.value
        settings.webPageZoomVal = webPageZoom.value
        settings.sync()
    }

    Settings {
        id: settings
        property string url: "https://www.google.de"
        property int reloadVal: 2000
        property int webPageZoomVal: 100
    }

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter

        RowLayout {
            Layout.fillWidth: true

            GroupBox {
                id: groupVisu
                title: qsTr( "Visu" )
                Layout.fillWidth: true

                Layout.minimumWidth: 200
                Layout.preferredWidth: 800

                GridLayout {
                    anchors.fill: parent
                    columns: 2
                    rows: 4

                    Label {
                        text: qsTr( "Visu Url:" );
                    }

                    TextField {
                        id : urlText
                        Layout.fillWidth: true
                        text: settings.url
                    }

                    Label {
                        text: qsTr( "Visu Zoom:" )
                    }

                    SpinBox {
                        id : webPageZoom
                        Layout.fillWidth: true

                        from: 25
                        value: settings.webPageZoomVal
                        to: 500
                        stepSize: 5

                        property real realValue: value / 100

                        Settings {
                            property alias value: webPageZoom.value
                        }
                    } // SpinBox

                    Label {
                        text: qsTr( "Visu Reload-Timeout [ms]:" )
                    }
                    SpinBox {
                        id: reloadSpinBox
                        from: 200
                        to: 10000
                        stepSize: 100
                        value: settings.reloadVal
                        Layout.fillWidth: true
                    }

                    Button {
                        id: reloadBtn
                        text: qsTr( "Reload" )
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        onClicked: {
                            reloadUrl();
                            showBrowser();
                        }
                    }

                } // GridLayout
            } // GroupBox

        } // RowLayout

        Button {
            id: minimizeBtn
            text: qsTr( "Minimize Window" )
            Layout.fillWidth: true
            onClicked: {
                minimizeApp()
            }
        }

        Item {
            Layout.fillHeight: true
        }

        Button {
            id: quitApp
            text: qsTr( "Quit" )
            Layout.fillWidth: true

            onClicked: {
                closeApp();
            }
        }
        Item {
            Layout.fillHeight: true
        }

    } // RowLayout
}
