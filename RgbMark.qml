import QtQuick

// Tiny 3×5 pixel "RGB". G and B fade out when red light is on; R stays put.
Item {
  id: root

  property bool checked: false
  property color color: "white"
  property int px: 2
  property int letterGap: 1

  readonly property var maps: ({
    "R": ["111", "101", "111", "110", "101"],
    "G": ["111", "100", "101", "101", "111"],
    "B": ["110", "101", "110", "101", "110"]
  })
  readonly property int letterW: 3 * px
  readonly property int letterH: 5 * px
  readonly property int clusterW: letterW * 3 + letterGap * 2

  implicitWidth: clusterW
  implicitHeight: letterH

  Row {
    spacing: root.letterGap
    anchors.centerIn: parent

    PixelLetter { letter: "R" }

    PixelLetter {
      letter: "G"
      opacity: root.checked ? 0 : 1
      Behavior on opacity {
        NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
      }
    }

    PixelLetter {
      letter: "B"
      opacity: root.checked ? 0 : 1
      Behavior on opacity {
        NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
      }
    }
  }

  component PixelLetter: Item {
    property string letter: "R"

    width: root.letterW
    height: root.letterH

    Repeater {
      model: 15

      Rectangle {
        required property int index
        readonly property int col: index % 3
        readonly property int row: Math.floor(index / 3)
        readonly property var rows: root.maps[letter] || ["000", "000", "000", "000", "000"]

        visible: rows[row].charAt(col) === "1"
        x: col * root.px
        y: row * root.px
        width: root.px
        height: root.px
        color: root.color
        antialiasing: false
      }
    }
  }
}
