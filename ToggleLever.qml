import QtQuick

// Vintage electronics toggle: metal housing with a ball-bearing lever.
// Up = on, down = off. Sized for the 16px bar icon canvas.
Item {
  id: root

  property bool checked: false
  property color color: "white"

  readonly property real ball: Math.max(5, width * 0.42)
  readonly property real stemW: Math.max(1.5, width * 0.13)
  readonly property real stemH: height * 0.42
  readonly property real houseW: width * 0.72
  readonly property real houseH: Math.max(3.5, height * 0.22)

  Item {
    id: lever
    width: root.width
    height: root.height * 0.78
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: house.top
    anchors.bottomMargin: -root.stemW
    transformOrigin: Item.Bottom
    rotation: root.checked ? -40 : 40

    Behavior on rotation {
      NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
    }

    Rectangle {
      width: root.stemW
      height: root.stemH
      radius: width / 2
      color: root.color
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
    }

    Rectangle {
      id: knob
      width: root.ball
      height: root.ball
      radius: width / 2
      color: root.color
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: root.stemH - root.ball * 0.18

      Rectangle {
        width: parent.width * 0.34
        height: width
        radius: width / 2
        color: Qt.lighter(root.color, 1.55)
        opacity: 0.7
        x: parent.width * 0.22
        y: parent.height * 0.18
      }
    }
  }

  Rectangle {
    id: house
    width: root.houseW
    height: root.houseH
    radius: height * 0.38
    color: root.color
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
  }
}
