import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  property var pluginApi: null

  property bool showCount: pluginApi?.pluginSettings?.showCountInBar ?? true
  property string vaultPath: pluginApi?.pluginSettings?.vaultPath ?? "~/Notes"
  property bool gitAutoPush: pluginApi?.pluginSettings?.gitAutoPush ?? false

  spacing: Style.marginM

  NLabel {
    label: "Notes Folder"
    description: "Path to your notes folder (e.g. ~/Notes or ~/Documents/Obsidian/MyVault)"
  }

  NTextInput {
    id: vaultPathInput
    Layout.fillWidth: true
    text: root.vaultPath
    placeholderText: "~/Notes"
    onTextChanged: root.vaultPath = text
  }

  NToggle {
    label: "Git Auto Push"
    description: "After saving, run git add, commit and push in the notes folder (requires a .git repo there)"
    checked: root.gitAutoPush
    onToggled: (checked) => {
      root.gitAutoPush = checked;
    }
  }

  NToggle {
    label: pluginApi?.tr("settings.show_count.label") || "Show Note Count"
    description: pluginApi?.tr("settings.show_count.description") || "Show the number of notes in the bar widget"
    checked: root.showCount
    onToggled: (checked) => {
      root.showCount = checked;
    }
  }

  function saveSettings() {
    if (pluginApi) {
      pluginApi.pluginSettings.showCountInBar = root.showCount;
      pluginApi.pluginSettings.vaultPath = root.vaultPath;
      pluginApi.pluginSettings.gitAutoPush = root.gitAutoPush;
      pluginApi.saveSettings();
    }
  }
}
