import QtQuick 2.9
import QtQuick.Controls 1.1

Rectangle {
    id: view
    width: 800
    height: 480
    color: "transparent"//customizerItem.currentStyleDark ? "#111" : "#555"

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            stackView.pop();
            event.accepted = true;
        }
    }

    property real value: 0.0
    SequentialAnimation {
        running: true
        loops: 1//AnimatedSprite.Infinite
        NumberAnimation { target: view; property: "value"; from: 1; to: 9; duration: 10000 }
        NumberAnimation { target: view; property: "value"; from: 9; to:1; duration: 10000 }
    }

    Item {
        id: rpmNum
        x: 69
        y: 215
        width: 640
        height: 50
        Repeater {
            model: 10
            Text {
                width: 20
                height: 28
                // 数值64为两个rpm数值之间距离+数值本身宽度
                // 数值640为整个rpm数值排列在一起的宽度即10个数值宽度+10个两个数值之间的距离
                x: (64 * ((index + 5) % 10) - (64 * value) + 640) % 640
                // y与x的位置关系为一元二次方程
                y: -0.0002 * x * x + 0.117 * x + 4.9298
                text: index
                color: "red"
                font.pixelSize: 24
//                font.family: UiController.font["AutoIO4"]
            }
        }
    }
//    Loader {
//        id: customizerLoader
//        sourceComponent: customizer
//       ` opacity: 0
//        anchors.left: parent.left
//        anchors.right: parent.right
//        anchors.leftMargin: 30
//        anchors.rightMargin: 30
//        y: parent.height / 2 - height / 2 - toolbar.height
//        visible: customizerLoader.opacity > 0

//        property alias view: view

//        Behavior on y {
//            NumberAnimation {
//                duration: 300
//            }
//        }

//        Behavior on opacity {
//            NumberAnimation {
//                duration: 300
//            }
//        }
//    }

//    ControlViewToolbar {
//        id: toolbar

//        onCustomizeClicked: {
//            customizerLoader.opacity = customizerLoader.opacity == 0 ? 1 : 0;
//        }
//    }
}
