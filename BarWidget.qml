import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "payton.redlight"

  property bool redOn: false

  readonly property string pluginDir: {
    var s = String(Qt.resolvedUrl("./"))
    if (s.indexOf("file://") === 0)
      s = s.substring(7)
    return s
  }
  readonly property string toggleBin: pluginDir + "scripts/omarchy-toggle-redlight"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function refresh() {
    if (!probe.running)
      probe.running = true
  }

  function restore() {
    if (!restoreProc.running)
      restoreProc.running = true
  }

  IpcHandler {
    target: "payton.redlight"

    function refresh(): void {
      root.broadcast("refresh")
    }
  }

  FileView {
    path: `${Quickshell.env("HOME")}/.local/state/omarchy`
    watchChanges: true
    printErrors: false
    onFileChanged: root.refresh()
  }

  Process {
    id: restoreProc
    command: [root.toggleBin, "restore-if-enabled"]
    onExited: root.refresh()
  }

  Process {
    id: probe
    command: ["bash", "-c", "[[ -f $HOME/.local/state/omarchy/redlight-enabled ]] && echo yes || echo no"]
    stdout: SplitParser {
      onRead: function (line) {
        root.redOn = String(line).trim() === "yes"
      }
    }
  }

  Timer {
    id: reconcileTimer
    interval: 250
    repeat: false
    onTriggered: root.refresh()
  }

  Component.onCompleted: root.restore()

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "RGB"
    dimmed: !root.redOn
    active: root.redOn
    useActiveColor: false
    slotSize: 28
    opticalSize: 24
    fontSize: Style.font.caption
    tooltipText: root.redOn ? "Turn Off Red Light" : "Red Light"
    iconComponent: Component {
      Item {
        RgbMark {
          anchors.centerIn: parent
          checked: root.redOn
          color: root.bar ? root.bar.barForeground : button.foreground
          pixelSize: 13
        }
      }
    }
    onPressed: function () {
      root.redOn = !root.redOn
      if (root.bar)
        root.bar.run(Util.shellQuote(root.toggleBin))
      reconcileTimer.restart()
    }
  }
}
