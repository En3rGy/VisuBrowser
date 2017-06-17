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
    title: Qt.application.displayName
    visibility: "FullScreen"

    function slot_resume() {
        console.log('System resumed');
        browser.url = configPage.sUrl;
    }

    function slot_suspend() {
        console.log('System going to suspend');
    }  // slot

    signal signal_quitApp()

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
            onLoadingChanged: {
                if (loadRequest.status === WebEngineView.LoadStartedStatus) {
                    console.log("Loading started: ", browser.url );
                    buisyInd.running = true;
                }

                if (loadRequest.status === WebEngineView.LoadFailedStatus) {
                    console.log("Load failed! Error code: " + loadRequest.errorCode);
                    browser.url = configPage.sUrl;
                    retryTimer.interval = configPage.reloadTimeout;
                    retryTimer.start();
                    buisyInd.running = false;
                }

                if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                    console.log("Page loaded!");
                    buisyInd.running = false;

                    if ( title === "Error" ) {
                        console.log("HS error page");
                        browser.url = configPage.sUrl;
                        retryTimer.interval = configPage.reloadTimeout;
                        retryTimer.start();
                        //browser.url = ":/html/ressources/msg.html";
                    }
                    else {
                        findText("Timeout !!", WebEngineView.FindCaseSensitively, function(success) {
                            if (success) {
                                console.log("HS visu timeout");
                                browser.url = configPage.sUrl;
                                retryTimer.interval = configPage.reloadTimeout;
                                retryTimer.start();
                                //browser.url = ":/html/ressources/msg.html"
                            }
                        });
                        findText("User kidnapped !!", WebEngineView.FindCaseSensitively, function(success) {
                            if (success) {
                                console.log("HS user kidnapped");
                                browser.url = configPage.sUrl;
                                retryTimer.interval = configPage.reloadTimeout;
                                retryTimer.start();
                                //browser.url = ":/html/ressources/msg.html"
                            }
                        });
                    } // else

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
                browser.url = configPage.sUrl;
                retryTimer.interval = 250;
                retryTimer.start();
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
