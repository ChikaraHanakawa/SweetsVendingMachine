import QtQuick

Window {
    visible: true
    width: 580
    height: 460
    color: "#15202B"
    title: "ずんだもんじはんき"

    Row {
        anchors.centerIn: parent
        spacing: 40

        AnimatedImage {
            source: "assets/zunda-soldout-sign.gif"
            fillMode: Image.PreserveAspectFit
            smooth: true; playing: true; asynchronous: true
            width: 240; height: 240
        }

        AnimatedImage {
            source: "assets/zunda-preparing.gif"
            fillMode: Image.PreserveAspectFit
            smooth: true; playing: true; asynchronous: true
            width: 240; height: 240
        }
    }
}
