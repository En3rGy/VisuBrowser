import QtQml 2.2
import QtQuick 2.8
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtWebEngine 1.1
import QtQuick.Layouts 1.1

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("VisuBrowser")
    visibility: "FullScreen"

    Component.onCompleted: {
        console.log('System started...')
        systemStartTimer.start()
    }


    Timer {
        id: systemStartTimer
        repeat: false
        interval: 1000
        onTriggered: signal_sendStatus( "<ServerRunning>1</ServerRunning>", configPage.sStatusReceiverAddr, configPage.nStatusReceiverPort )
    }

    function slot_resume() {
        console.log('System resumed')
        signal_sendStatus( "<ServerRunning>1</ServerRunning>", configPage.sStatusReceiverAddr, configPage.nStatusReceiverPort )
        browser.url = configPage.sUrl
    }

    function slot_suspend() {
        console.log('System going to suspend')
        signal_sendStatus( "<ServerRunning>0</ServerRunning>", configPage.sStatusReceiverAddr, configPage.nStatusReceiverPort )
    }  // slot

    signal signal_sendStatus( string sStatus, string sAddr, int nPort )

    signal signal_quitApp()

    Timer{
        id: retryTimer
        repeat: false
        onTriggered: {
            browser.reloadAndBypassCache()
        }
    }

    SwipeView {
        id: swipeView
        wheelEnabled: false
        anchors.fill: parent
        currentIndex: pageIndicator.currentIndex

        WebEngineView {
            id: browser
            url: configPage.sUrl
            zoomFactor: configPage.webPageZoomVal
            onLoadingChanged: {
                if (loadRequest.status === WebEngineView.LoadStartedStatus)
                    console.log("Loading started...");

                if (loadRequest.status === WebEngineView.LoadFailedStatus) {
                    console.log("Load failed! Error code: " + loadRequest.errorCode);
                    retryTimer.interval = configPage.reloadTimeout
                    retryTimer.start()
                }

                if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                    console.log("Page loaded!");

                    findText("Timeout !!", WebEngineView.FindCaseSensitively, function(success) {
                        if (success) {
                            browser.url = configPage.sUrl
                            console.log("HS visu timeout");
                        }
                    });

                }
            }
        }

        PageConfig {
            id: configPage

            onCloseApp: {
                console.log('Closing app...')
                signal_sendStatus( "<ServerRunning>0</ServerRunning>", configPage.sStatusReceiverAddr, configPage.nStatusReceiverPort )
                signal_quitApp()
            }
        }

    } // SwipeView

    PageIndicator {
        id: pageIndicator
        currentIndex: swipeView.currentIndex
        count: swipeView.count
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        interactive: true
    }
}

