import QtQuick

Item {
    id: root
    implicitWidth: 110
    implicitHeight: 110

    // "soldOut" or "preparing"
    property string mode: "soldOut"

    AnimatedImage {
        anchors.fill: parent
        source: root.mode === "soldOut"
            ? "../assets/soldout-zunda.gif"
            : "../assets/zunda-white.gif"
        fillMode: Image.PreserveAspectFit
        playing: true
        smooth: true
        asynchronous: true
    }
}
