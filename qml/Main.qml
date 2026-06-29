import QtQuick
import "components"

Window {
    visible: true
    width: 500
    height: 460
    color: "#15202B"
    title: "BigButton Demo"

    Column {
        anchors.centerIn: parent
        spacing: 28

        BigButton {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "sample1"
            baseColor: "#1D9E75"
            onClicked: console.log("sample1 選択")
        }

        BigButton {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "sample2"
            baseColor: "#378ADD"
            depth: 9                  // 沈み込みを強くした例
            onClicked: console.log("sample2 選択")
        }

        BigButton {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "sample3"
            baseColor: "#C0392B"
            cornerRadius: 32          // 丸みを強くした例
            onClicked: console.log("sample3 選択")
        }

        BigButton {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "売り切れ"
            enabled: false
        }
    }
}
