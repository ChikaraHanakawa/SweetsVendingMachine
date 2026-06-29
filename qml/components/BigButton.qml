import QtQuick

Item {
    id: root

    // --- Public API ---
    property string text: ""
    property color baseColor: "#4A90D9"
    property color pressedColor: Qt.darker(baseColor, 1.4)
    property color edgeColor:    Qt.darker(baseColor, 1.75)
    property color textColor: "white"
    property int depth: 6
    property int cornerRadius: 14
    property int fontSize: 22
    property bool fontBold: true

    signal clicked()

    implicitWidth:  220
    implicitHeight: 68 + depth

    // 視覚的な押し込み状態（実際のpress/releaseより最低100ms保持）
    property bool visuallyPressed: false

    Timer {
        id: releaseTimer
        interval: 100   // 押した見た目を最低100ms維持
        onTriggered: root.visuallyPressed = false
    }

    // ── Edge: root全体を覆うことで角丸の隙間から背景が透けるのを防ぐ ──
    Rectangle {
        id: edgeRect
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.enabled ? root.edgeColor : "#4a4a4a"

        Behavior on color { ColorAnimation { duration: 120 } }
    }

    // ── Button face (slides down on press) ───────────────────────────────
    Rectangle {
        id: face
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height - root.depth
        radius: root.cornerRadius

        Text {
            anchors.centerIn: parent
            text: root.text
            font.pixelSize: root.fontSize
            font.bold: root.fontBold
            color: root.textColor
            opacity: root.enabled ? 1.0 : 0.50
        }
    }

    // ── States ───────────────────────────────────────────────────────────
    states: [
        State {
            name: "normal"
            when: !root.visuallyPressed
            PropertyChanges {
                target: face
                y: 0
                color: root.enabled ? root.baseColor : "#777777"
            }
        },
        State {
            name: "pressed"
            when: root.visuallyPressed
            PropertyChanges { target: face; y: root.depth; color: root.pressedColor }
        }
    ]

    // ── Transitions ──────────────────────────────────────────────────────
    transitions: [
        Transition {
            from: "normal"; to: "pressed"
            NumberAnimation { target: face; property: "y";     duration: 70;  easing.type: Easing.OutQuart }
            ColorAnimation  { target: face; property: "color"; duration: 70 }
        },
        Transition {
            from: "pressed"; to: "normal"
            NumberAnimation {
                target: face; property: "y"
                duration: 200
                easing.type: Easing.OutBack
                easing.overshoot: 2.5
            }
            ColorAnimation  { target: face; property: "color"; duration: 130 }
        }
    ]

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: {
            if (!root.enabled) return
            root.visuallyPressed = true
            releaseTimer.stop()
        }
        onReleased: {
            releaseTimer.restart()   // 100ms後にアニメ開始
        }
        onCanceled: {
            releaseTimer.restart()
        }
        onClicked: root.clicked()
    }
}
