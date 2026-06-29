import QtQuick

Item {
    id: root
    implicitWidth: 200
    implicitHeight: 185

    property string productName: ""
    property string productEmoji: "🍬"
    property int price: 100
    // "available", "soldOut", "preparing"
    property string status: "available"
    property color baseColor: "#4A90D9"

    signal purchased()

    Rectangle {
        id: card
        anchors.fill: parent
        radius: 18
        color: root.status === "available" ? root.baseColor : "#E8EDF2"
        border.color: root.status === "available"  ? Qt.darker(root.baseColor, 1.4)
                    : root.status === "soldOut"     ? "#EF9A9A"
                    : "#FFE082"
        border.width: 3

        // ── Available ──────────────────────────────────────────────────────
        Column {
            visible: root.status === "available"
            anchors.centerIn: parent
            spacing: 6

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.productEmoji
                font.pixelSize: 40
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.productName
                font.pixelSize: 14
                font.bold: true
                color: "white"
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "¥" + root.price
                font.pixelSize: 22
                font.bold: true
                color: "#FFE082"
            }
        }

        // ── Unavailable ────────────────────────────────────────────────────
        Column {
            visible: root.status !== "available"
            anchors.centerIn: parent
            width: 190
            spacing: 4

            Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: root.productEmoji + " " + root.productName
                font.pixelSize: 12
                color: "#90A4AE"
            }

            ZundamonCharacter {
                anchors.horizontalCenter: parent.horizontalCenter
                mode: root.status === "soldOut" ? "soldOut" : "preparing"
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 132; height: 26; radius: 13
                color: root.status === "soldOut" ? "#FFEBEE" : "#FFFDE7"
                border.color: root.status === "soldOut" ? "#EF5350" : "#FFC107"
                border.width: 2

                SequentialAnimation on scale {
                    running: true; loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 1.06; duration: 750; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 1.06; to: 1.0; duration: 750; easing.type: Easing.InOutSine }
                }

                Text {
                    anchors.centerIn: parent
                    text: root.status === "soldOut" ? "売り切れだよ♪" : "準備中だよ♪"
                    font.pixelSize: 13
                    font.bold: true
                    color: root.status === "soldOut" ? "#C62828" : "#E65100"
                }
            }
        }
    }

    MouseArea {
        anchors.fill: card
        enabled: root.status === "available"
        onClicked: {
            pressAnim.restart()
            root.purchased()
        }
    }

    SequentialAnimation {
        id: pressAnim
        NumberAnimation { target: card; property: "scale"; to: 0.93; duration: 80; easing.type: Easing.OutQuad }
        NumberAnimation { target: card; property: "scale"; to: 1.0; duration: 230; easing.type: Easing.OutBack; easing.overshoot: 2.2 }
    }
}
