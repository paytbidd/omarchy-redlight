import QtQuick

// Chicago Kare (bitmap Chicago) RGB at 13px. G and B fade when red is on.
Item {
  id: root

  property bool checked: false
  property color color: "white"
  property int pixelSize: 13
  property url fontUrl: Qt.resolvedUrl("fonts/ChicagoKare-Regular.ttf")

  FontLoader {
    id: chicago
    source: root.fontUrl
  }

  readonly property string family: chicago.status === FontLoader.Ready ? chicago.name : "Chicago Kare"

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  Row {
    id: row
    spacing: 0
    anchors.centerIn: parent

    PixelLetter { text: "R" }

    PixelLetter {
      text: "G"
      opacity: root.checked ? 0 : 1
      Behavior on opacity {
        NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
      }
    }

    PixelLetter {
      text: "B"
      opacity: root.checked ? 0 : 1
      Behavior on opacity {
        NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
      }
    }
  }

  component PixelLetter: Text {
    textFormat: Text.PlainText
    color: root.color
    font.family: root.family
    font.pixelSize: root.pixelSize
    font.kerning: false
    font.hintingPreference: Font.PreferFullHinting
    renderType: Text.NativeRendering
  }
}
