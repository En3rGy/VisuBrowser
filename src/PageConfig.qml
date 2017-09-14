import Qt.labs.settings 1.0
import QtQml 2.2
import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

Item {
    property alias  webPageZoomVal : webPageZoom.realValue
    property string sUrl: settings.sUrl
    property alias  reloadTimeout : reloadSpinBox.value
    property alias  sStatusReceiverAddr : statusReceiverIp.text
    property alias  nStatusReceiverPort : statusReceiverPort.value

    signal closeApp()

    signal reloadUrl()

    signal minimizeApp()

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: Qt.application.displayName
            Layout.fillWidth: true
        }

        GroupBox {
            title: qsTr( "Visu" )
            Layout.fillWidth: true

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
                    placeholderText: "http://www.google.de"
                    text: settings.sUrl
                    onEditingFinished: {
                        sUrl = urlText.text
                    }
                }

                Label {
                    text: qsTr( "Visu Zoom:" )
                }

                SpinBox {
                    id : webPageZoom
                    Layout.fillWidth: true

                    from: 25
                    value: settings.webPageZoom
                    to: 500
                    stepSize: 5

                    property int decimals: 2
                    property real realValue: value / 100

                    validator: DoubleValidator {
                        bottom: Math.min(webPageZoom.from, webPageZoom.to)
                        top:  Math.max(webPageZoom.from, webPageZoom.to)
                    }

                    textFromValue: function(value, locale) {
                        return Number(value / 100).toLocaleString(locale, 'f', webPageZoom.decimals);
                    }

                    valueFromText: function(text, locale) {
                        return Number.fromLocaleString(locale, text) * 100;
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
                    value: settings.nReloadTimeout
                    Layout.fillWidth: true
                }

                Button {
                    id: reloadBtn
                    text: qsTr( "Reload" )
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    onClicked: {
                        reloadUrl();
                    }
                }

            } // GridLayout
        } // GroupBox

        GroupBox{
            title: qsTr( "UDP Status" )
            Layout.fillWidth: true

            GridLayout {
                anchors.fill: parent
                columns: 2
                rows: 2

                Label {
                    text: qsTr( "Status Receiver IP:" );
                }

                TextField {
                    id : statusReceiverIp
                    Layout.fillWidth: true
                    text: settings.sStatusReceiverUrl
                    onEditingFinished: {
                    }
                }

                Label {
                    text: qsTr( "Status Receiver Port:" )
                }
                SpinBox {
                    id: statusReceiverPort
                    from: 0
                    to: 10000
                    stepSize: 1
                    value: settings.nStatusReceivePort
                    Layout.fillWidth: true
                }
            } // GridLayout
        } // Item

        Button {
            id: saveSettings
            text: qsTr( "Save Settings" )
            Layout.fillWidth: true
            onClicked: {
                settings.webPageZoom  = webPageZoom.value;
                settings.sUrl = urlText.text;
                settings.nStatusReceivePort = statusReceiverPort.value;
                settings.sStatusReceiverUrl = statusReceiverIp.text;
                settings.nReloadTimeout = reloadSpinBox.value;
            }
        }

        Button {
            id: minimizeBtn
            text: qsTr( "Minimize Window" )
            Layout.fillWidth: true
            onClicked: {
                minimizeApp()
            }
        }

        Button {
            id: quitApp
            text: qsTr( "Quit" )
            Layout.fillWidth: true
            onClicked: {
                closeApp();
            }
        }
    } // RowLayout

    Settings {
        id : settings

        property int webPageZoom : 100
        property string sUrl : "http://www.google.de"
        property int nStatusReceivePort : 2001
        property int nReloadTimeout : 2000
        property string sStatusReceiverUrl : "192.168.143.11"
    }
}
