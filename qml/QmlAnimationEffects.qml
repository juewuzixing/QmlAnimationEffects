/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.0
import QtQuick.Window 2.1

Window {
    id: root
    objectName: "window"
    visible: true
    width: 800
    height: 480

    color: "#161616"
    title: "Qt Quick Extras Demo"

    function toPixels(percentage) {
        return percentage * Math.min(root.width, root.height);
    }

    property bool isScreenPortrait: height > width
    property color lightFontColor: "#222"
    property color darkFontColor: "#e7e7e7"
    readonly property color lightBackgroundColor: "#cccccc"
    readonly property color darkBackgroundColor: "#161616"
    property real customizerPropertySpacing: 10
    property real colorPickerRowSpacing: 8

    Text {
        id: textSingleton
    }
    property Component timeFormat: ControlView {
        Item {
            id: timeFormatPanel
            x: 400
            y: 215
            width: 74
            height: 23

            property string timeStr: "18:00:00"
            function timeFormatConvert(timeStr) {
                var ts = timeStr;
                var H = +ts.substr(0, 2);
                var h = (H % 12) || 12;
                // 前导0
                h = (h < 10) ? ("0" + h) : h;
                // 依情况显示AM或者PM
                var ampm = H < 12 ? " AM" : " PM";
                ts = h + ts.substr(2, 3) + ampm;
                return ts;
            }

            Text {
                text: timeFormatPanel.timeFormatConvert(timeFormatPanel.timeStr)
                color: "red"
                anchors.centerIn: parent
                font.pixelSize: 19
            }
        }
    }
    property Component pathView: ControlView {
        id: pathViewItem
        property real value: 0.0
        SequentialAnimation {
            running: true
            loops: AnimatedSprite.Infinite
            NumberAnimation { target: pathViewItem; property: "value"; from: 1; to: 9; duration: 10000 }
            NumberAnimation { target: pathViewItem; property: "value"; from: 9; to:1; duration: 10000 }
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
                }
            }
        }
    }

    property Component circularGauge: CircularGaugeView {}

    property Component dial: ControlView {
        darkBackground: false

        control: Column {
            id: dialColumn
            width: controlBounds.width
            height: controlBounds.height - spacing
            spacing: root.toPixels(0.05)

            ColumnLayout {
                id: volumeColumn
                width: parent.width
                height: (dialColumn.height - dialColumn.spacing) / 2
                spacing: height * 0.025

                Dial {
                    id: volumeDial
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    /*!
                        Determines whether the dial animates its rotation to the new value when
                        a single click or touch is received on the dial.
                    */
                    property bool animate: customizerItem.animate

                    Behavior on value {
                        enabled: volumeDial.animate && !volumeDial.pressed
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutSine
                        }
                    }
                }

                ControlLabel {
                    id: volumeText
                    text: "Volume"
                    Layout.alignment: Qt.AlignCenter
                }
            }

            ColumnLayout {
                id: trebleColumn
                width: parent.width
                height: (dialColumn.height - dialColumn.spacing) / 2
                spacing: height * 0.025

                Dial {
                    id: dial2
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    stepSize: 1
                    maximumValue: 10

                    style: DialStyle {
                        labelInset: outerRadius * 0
                    }
                }

                ControlLabel {
                    id: trebleText
                    text: "Treble"
                    Layout.alignment: Qt.AlignCenter
                }
            }
        }

        customizer: Column {
            spacing: customizerPropertySpacing

            property alias animate: animateCheckBox.checked

            CustomizerLabel {
                text: "Animate"
            }

            CustomizerSwitch {
                id: animateCheckBox
            }
        }
    }

    property Component delayButton: ControlView {
        darkBackground: false

        control: DelayButton {
            text: "Alarm"
            anchors.centerIn: parent
        }
    }

    property Component gauge: ControlView {
        id: gaugeView
        control: Gauge {
            id: gauge
            width: orientation === Qt.Vertical ? implicitWidth : gaugeView.controlBounds.width
            height: orientation === Qt.Vertical ? gaugeView.controlBounds.height : implicitHeight
            anchors.centerIn: parent

            minimumValue: 0
            value: customizerItem.value
            maximumValue: 100
            orientation: customizerItem.orientationFlag ? Qt.Vertical : Qt.Horizontal
            tickmarkAlignment: orientation === Qt.Vertical
                ? (customizerItem.alignFlag ? Qt.AlignLeft : Qt.AlignRight)
                : (customizerItem.alignFlag ? Qt.AlignTop : Qt.AlignBottom)
        }

        customizer: Column {
            spacing: customizerPropertySpacing

            property alias value: valueSlider.value
            property alias orientationFlag: orientationCheckBox.checked
            property alias alignFlag: alignCheckBox.checked

            CustomizerLabel {
                text: "Value"
            }

            CustomizerSlider {
                id: valueSlider
                minimumValue: 0
                value: 50
                maximumValue: 100
            }

            CustomizerLabel {
                text: "Vertical orientation"
            }

            CustomizerSwitch {
                id: orientationCheckBox
                checked: true
            }

            CustomizerLabel {
                text: controlItem.orientation === Qt.Vertical ? "Left align" : "Top align"
            }

            CustomizerSwitch {
                id: alignCheckBox
                checked: true
            }
        }
    }

    property Component toggleButton: ControlView {
        darkBackground: false

        control: ToggleButton {
            text: checked ? "On" : "Off"
            anchors.centerIn: parent
        }
    }

    property Component pieMenu: PieMenuControlView {}

    property Component statusIndicator: ControlView {
        id: statusIndicatorView
        darkBackground: false

        Timer {
            id: recordingFlashTimer
            running: true
            repeat: true
            interval: 1000
        }

        ColumnLayout {
            id: indicatorLayout
            width: statusIndicatorView.controlBounds.width * 0.25
            height: statusIndicatorView.controlBounds.height * 0.75
            anchors.centerIn: parent

            Repeater {
                model: ListModel {
                    id: indicatorModel
                    ListElement {
                        name: "Power"
                        indicatorColor: "#35e02f"
                    }
                    ListElement {
                        name: "Recording"
                        indicatorColor: "red"
                    }
                }

                ColumnLayout {
                    Layout.preferredWidth: indicatorLayout.width
                    spacing: 0

                    StatusIndicator {
                        id: indicator
                        color: indicatorColor
                        Layout.preferredWidth: statusIndicatorView.controlBounds.width * 0.07
                        Layout.preferredHeight: Layout.preferredWidth
                        Layout.alignment: Qt.AlignHCenter
                        on: true

                        Connections {
                            target: recordingFlashTimer
                            onTriggered: if (name == "Recording") indicator.active = !indicator.active
                        }
                    }
                    ControlLabel {
                        id: indicatorLabel
                        text: name
                        Layout.alignment: Qt.AlignHCenter
                        Layout.maximumWidth: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }

    property Component tumbler: ControlView {
        id: tumblerView
        darkBackground: false

        Tumbler {
            id: tumbler
            anchors.centerIn: parent

            // TODO: Use FontMetrics with 5.4
            Label {
                id: characterMetrics
                font.bold: true
                font.pixelSize: textSingleton.font.pixelSize * 1.25
                font.family: openSans.name
                visible: false
                text: "M"
            }

            readonly property real delegateTextMargins: characterMetrics.width * 1.5
            readonly property var days: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

            TumblerColumn {
                id: tumblerDayColumn

                function updateModel() {
                    var previousIndex = tumblerDayColumn.currentIndex;
                    var newDays = tumbler.days[monthColumn.currentIndex];

                    if (!model) {
                        var array = [];
                        for (var i = 0; i < newDays; ++i) {
                            array.push(i + 1);
                        }
                        model = array;
                    } else {
                        // If we've already got days in the model, just add or remove
                        // the minimum amount necessary to make spinning the month column fast.
                        var difference = model.length - newDays;
                        if (model.length > newDays) {
                            model.splice(model.length - 1, difference);
                        } else {
                            var lastDay = model[model.length - 1];
                            for (i = lastDay; i < lastDay + difference; ++i) {
                                model.push(i + 1);
                            }
                        }
                    }

                    tumbler.setCurrentIndexAt(0, Math.min(newDays - 1, previousIndex));
                }
            }
            TumblerColumn {
                id: monthColumn
                width: characterMetrics.width * 3 + tumbler.delegateTextMargins
                model: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
                onCurrentIndexChanged: tumblerDayColumn.updateModel()
            }
            TumblerColumn {
                width: characterMetrics.width * 4 + tumbler.delegateTextMargins
                model: ListModel {
                    Component.onCompleted: {
                        for (var i = 2000; i < 2100; ++i) {
                            append({value: i.toString()});
                        }
                    }
                }
            }
        }
    }


    FontLoader {
        id: openSans
        source: "qrc:/fonts/OpenSans-Regular.ttf"
     }

    property var componentMap: {
        "TimeFormat": timeFormat,
        "PathView": pathView,
        "CircularGauge": circularGauge,
        "DelayButton": delayButton,
        "Dial": dial,
        "Gauge": gauge,
        "PieMenu": pieMenu,
        "StatusIndicator": statusIndicator,
        "ToggleButton": toggleButton,
        "Tumbler": tumbler
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: ListView {
            model: ListModel {
                ListElement {
                    title: "TimeFormat"
                }
                ListElement {
                    title: "PathView"
                }
                ListElement {
                    title: "CircularGauge"
                }
                ListElement {
                    title: "DelayButton"
                }
                ListElement {
                    title: "Dial"
                }
                ListElement {
                    title: "Gauge"
                }
                ListElement {
                    title: "PieMenu"
                }
                ListElement {
                    title: "StatusIndicator"
                }
                ListElement {
                    title: "ToggleButton"
                }
                ListElement {
                    title: "Tumbler"
                }
            }

            delegate: Button {
                width: stackView.width
                height: root.height * 0.125
                text: title

                style: BlackButtonStyle {
                    fontColor: root.darkFontColor
                    rightAlignedIconSource: "qrc:/images/icon-go.png"
                }

                onClicked: {
                    if (stackView.depth == 1) {
                        // Only push the control view if we haven't already pushed it...
                        stackView.push({item: componentMap[title]});
                        stackView.currentItem.forceActiveFocus();
                    }
                }
            }
        }
    }
}


