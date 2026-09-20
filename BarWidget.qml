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
    command: [root.toggleBin, "--enabled"]
    onExited: function (code) {
      root.redOn = (code === 0)
    }
  }

  Component.onCompleted: root.restore()

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: ""
    dimmed: !root.redOn
    active: root.redOn
    useActiveColor: false
    slotSize: Style.bar.statusSlot
    fontSize: Style.font.caption
    tooltipText: root.redOn ? "Turn Off Red Light" : "Red Light"
    onPressed: function () {
      if (root.bar)
        root.bar.run(Util.shellQuote(root.toggleBin))
      Qt.callLater(root.refresh)
    }
  }
}
