import QtQuick
import Qt.labs.platform
import qs.Services.UI

Item {
  property var pluginApi: null

  Component.onCompleted: {
    if (pluginApi) {
      if (pluginApi.pluginSettings.vaultPath === undefined) {
        pluginApi.pluginSettings.vaultPath = StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/Notes";
        pluginApi.saveSettings();
      }
      if (pluginApi.pluginSettings.showCountInBar === undefined) {
        pluginApi.pluginSettings.showCountInBar = true;
        pluginApi.saveSettings();
      }
      if (pluginApi.pluginSettings.count === undefined) {
        pluginApi.pluginSettings.count = 0;
        pluginApi.saveSettings();
      }
      if (pluginApi.pluginSettings.gitAutoPush === undefined) {
        pluginApi.pluginSettings.gitAutoPush = false;
        pluginApi.saveSettings();
      }
    }
  }
}
