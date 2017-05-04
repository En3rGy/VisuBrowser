import QtQuick 2.8
import QtQuick.Controls 2.1

Rectangle {
    property alias mouseArea: mouseArea

    width: 360
    height: 360

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }
}
