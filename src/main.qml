import QtQml 2.12
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtWebEngine 1.8
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.12


ApplicationWindow {

    id: mainApp
    visible: true
    width: 640
    height: 480
    title: Qt.application.displayName
    visibility: "FullScreen"

    signal signal_quitApp()
    signal signal_completed()

    Material.theme: Material.Dark
    Material.accent: Material.Purple

    function slot_resume() {
        console.log('System resumed');
        browser.url = configPage.sUrl;
    }

    function slot_suspend() {
        console.log('System going to suspend');
    }  // slot

    Timer{
        id: retryTimer
        repeat: false
        onTriggered: {
            browser.reloadAndBypassCache();
            retryTimer.stop();
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
            onLoadingChanged: function(loadingInfo){
                if (loadingInfo.status === WebEngineView.LoadStartedStatus) {
                    console.log("Loading started: ", browser.url );
                    buisyInd.running = true;
                }

                if (loadingInfo.status === WebEngineView.LoadFailedStatus) {
                    console.log("Load failed! Error code: " + loadRequest.errorCode);
                    browser.url = configPage.sUrl;
                    retryTimer.interval = configPage.reloadTimeout;
                    retryTimer.start();
                    buisyInd.running = false;
                }

                if (loadingInfo.status === WebEngineView.LoadSucceededStatus) {
                    console.log("Page loaded!");
                    buisyInd.running = false;

                    if ( title === "Error" ) {
                        console.log("HS error page");
                        browser.url = configPage.sUrl;
                        retryTimer.interval = configPage.reloadTimeout;
                        retryTimer.start();
                    }
                }
            }

            BusyIndicator {
                id: buisyInd
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                running: false
                z: 1
            }

        }

        PageConfig {
            id: configPage

            onCloseApp: {
                console.log('Closing app...')
                signal_quitApp()
            }

            onReloadUrl: {
                retryTimer.interval = 250;
                retryTimer.start();
            }

            onMinimizeApp: {
                mainApp.visibility = Window.Minimized
            }

            onShowBrowser: {
                swipeView.currentIndex = 0
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

    Component.onCompleted: {
        console.log("QML completed")
        signal_completed();
    }
}
