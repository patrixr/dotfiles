import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform as Platform
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  readonly property var geometryPlaceholder: panelContainer
  property real contentPreferredWidth: 900 * Style.uiScaleRatio
  property real contentPreferredHeight: 580 * Style.uiScaleRatio
  readonly property bool allowAttach: true
  anchors.fill: parent

  // ── State ────────────────────────────────────────────────────────────────
  property bool isEditing: false
  property string currentFileName: ""
  property string currentTitle: ""
  property string currentContent: ""
  property bool savedIndicatorVisible: false
  property bool isSaving: false
  property bool isCreating: false

  readonly property bool gitAutoPush: pluginApi?.pluginSettings?.gitAutoPush ?? false
  property var notesList: []         // [{ fileName, title, modifiedAt }]

  // ── Vault path ───────────────────────────────────────────────────────────
  // plainVault: plain filesystem path for use in shell commands
  // fileVault:  file:// URI for use in FileView.path
  readonly property string _home: Platform.StandardPaths.writableLocation(Platform.StandardPaths.HomeLocation).toString().replace(/^file:\/\/\//, "/").replace(/^file:\/\//, "")

  function expandPath(p) {
    var s = (p ?? (root._home + "/Notes")).toString();
    // strip file:// prefix if present (StandardPaths returns file:/// URIs)
    s = s.replace(/^file:\/\/\//, "/").replace(/^file:\/\//, "");
    if (s.startsWith("~/"))
      return root._home + s.slice(1);
    return s;
  }

  readonly property string plainVault: {
    var expanded = root.expandPath(pluginApi?.pluginSettings?.vaultPath ?? "~/Notes");
    return expanded.endsWith("/") ? expanded : expanded + "/";
  }

  readonly property string fileVault: "file://" + root.plainVault

  // ── Lifecycle ────────────────────────────────────────────────────────────
  Component.onCompleted: {
    if (pluginApi) loadNotesList();
  }

  onPluginApiChanged: {
    if (pluginApi) loadNotesList();
  }

  // ── List .md files ───────────────────────────────────────────────────────
  // ls -lt with epoch timestamps; falls back silently if folder is empty/absent
  Process {
    id: listProcess

    // accumulate stdout lines here
    property string _buf: ""

    command: ["bash", "-c",
      "find " + JSON.stringify(root.plainVault) + " -maxdepth 1 -name '*.md' -printf '%T@ %f\\n' 2>/dev/null | sort -rn"
    ]

    onStarted: {
      console.log("markdown-notes: listing vault:", root.plainVault);
    }

    stdout: SplitParser {
      onRead: data => listProcess._buf += data + "\n"
    }

    onRunningChanged: {
      if (!running) {
        console.log("markdown-notes: raw listing output:", JSON.stringify(listProcess._buf));
        root.parseFileList(listProcess._buf);
        listProcess._buf = "";
      }
    }
  }

  // ── Read a note ──────────────────────────────────────────────────────────
  FileView {
    id: noteReader
    blockLoading: true

    onLoaded: {
      root.currentContent = noteReader.text();
    }

    onLoadFailed: error => {
      console.warn("simple-notes: failed to read", noteReader.path, error);
      root.currentContent = "";
    }
  }

  // ── Write a note ─────────────────────────────────────────────────────────
  // Uses an env var to pass content to bash, avoiding stdin-close and quoting issues.
  Process {
    id: noteWriter
    property string pendingContent: ""
    property string pendingPath: ""

    environment: ({ "NOTE_CONTENT": noteWriter.pendingContent })

    onRunningChanged: {
      if (!running) {
        root.loadNotesList();
        if (root.gitAutoPush) {
          gitPushProcess.command = ["bash", "-c",
            "cd " + JSON.stringify(root.plainVault) + " && git add -A && git commit -m 'notes: save " + root.currentFileName + "' && git push 2>&1"
          ];
          gitPushProcess.running = true;
        } else {
          root.isSaving = false;
          root.savedIndicatorVisible = true;
          savedIndicatorTimer.restart();
        }
      }
    }
  }

  // ── Git auto-push ─────────────────────────────────────────────────────────
  Process {
    id: gitPushProcess
    property string _buf: ""

    stdout: SplitParser {
      onRead: data => console.log("markdown-notes git:", data)
    }

    stderr: SplitParser {
      onRead: data => console.warn("markdown-notes git stderr:", data)
    }

    onRunningChanged: {
      if (!running) {
        root.isSaving = false;
        root.savedIndicatorVisible = true;
        savedIndicatorTimer.restart();
      }
    }
  }

  function writeNote(filePath, content) {
    noteWriter.pendingPath = filePath;
    noteWriter.pendingContent = content;
    // Content passed via $NOTE_CONTENT env var — no stdin, no quoting issues
    noteWriter.command = ["bash", "-c", "printf '%s' \"$NOTE_CONTENT\" > " + JSON.stringify(filePath)];
    noteWriter.running = true;
  }

  // ── Delete a note ─────────────────────────────────────────────────────────
  Process {
    id: deleteProcess
    property string deletedFileName: ""

    onRunningChanged: {
      if (!running) {
        root.loadNotesList();
        if (root.gitAutoPush) {
          gitPushProcess.command = ["bash", "-c",
            "cd " + JSON.stringify(root.plainVault) + " && git add -A && git commit -m 'notes: delete " + deleteProcess.deletedFileName + "' && git push 2>&1"
          ];
          gitPushProcess.running = true;
        }
      }
    }
  }

  // ── Rename (title changed) ────────────────────────────────────────────────
  Process {
    id: renameProcess
    property string nextFileName: ""
    property string pendingContent: ""

    onRunningChanged: {
      if (!running) {
        root.currentFileName = renameProcess.nextFileName;
        root.currentTitle = root.currentFileName.slice(0, -3);
        root.writeNote(root.plainVault + root.currentFileName, renameProcess.pendingContent);
      }
    }
  }

  // ── mkdir -p before first write ───────────────────────────────────────────
  Process {
    id: mkdirProcess
    property string pendingFileName: ""
    property string pendingContent: ""

    onRunningChanged: {
      if (!running) {
        root.writeNote(root.plainVault + mkdirProcess.pendingFileName, mkdirProcess.pendingContent);
      }
    }
  }

  // ── Saved indicator timer (hides the indicator after a moment) ────────────
  Timer {
    id: savedIndicatorTimer
    interval: 2000
    repeat: false
    onTriggered: root.savedIndicatorVisible = false
  }

  // ── Functions ─────────────────────────────────────────────────────────────

  function loadNotesList() {
    // guard: resolvedVault not ready yet
    if (!root.plainVault || root.plainVault === "/") return;
    listProcess.running = false;
    listProcess.running = true;
  }

  // Parse `find -printf '%T@ %f\n'` output
  // Format: <epoch.fractional> <filename>
  function parseFileList(raw) {
    var lines = raw.trim().split("\n");
    var result = [];
    console.log("markdown-notes: parseFileList got", lines.length, "lines");
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim();
      if (line === "") continue;
      var spaceIdx = line.indexOf(" ");
      if (spaceIdx === -1) { console.log("markdown-notes: skipping line (no space):", JSON.stringify(line)); continue; }
      var epoch = parseFloat(line.slice(0, spaceIdx));
      var fileName = line.slice(spaceIdx + 1);
      console.log("markdown-notes: parsed epoch=" + epoch + " fileName=" + JSON.stringify(fileName));
      if (!fileName.endsWith(".md")) { console.log("markdown-notes: skipping, not .md"); continue; }
      var title = fileName.slice(0, -3);
      result.push({ fileName: fileName, title: title, modifiedAt: epoch * 1000 });
    }
    console.log("markdown-notes: notesList set to", result.length, "items");
    root.notesList = result;
    if (pluginApi) {
      pluginApi.pluginSettings.count = result.length;
      pluginApi.saveSettings();
    }
  }

  function titleToFileName(title) {
    return title.trim().replace(/[\/\\:*?"<>|]/g, "-").replace(/\s+/g, " ") + ".md";
  }

  function openNote(fileName, title) {
    root.isCreating = false;
    root.currentFileName = fileName;
    root.currentTitle = title;
    root.currentContent = "";
    noteReader.path = root.fileVault + fileName;
    noteReader.reload();
  }

  function createNote() {
    root.currentFileName = "";
    root.currentTitle = "";
    root.currentContent = "";
    root.isCreating = true;
  }

  function saveNote(title, content) {
    root.isCreating = false;
    if (!pluginApi) return;
    var safeTitle = title.trim() || "Untitled Note";
    var newFileName = titleToFileName(safeTitle);

    root.currentTitle = safeTitle;
    root.currentContent = content;
    root.isSaving = true;
    root.savedIndicatorVisible = false;

    if (root.currentFileName !== "" && root.currentFileName !== newFileName) {
      renameProcess.nextFileName = newFileName;
      renameProcess.pendingContent = content;
      renameProcess.command = ["mv",
        root.plainVault + root.currentFileName,
        root.plainVault + newFileName
      ];
      renameProcess.running = true;
    } else {
      root.currentFileName = newFileName;
      root.currentTitle = safeTitle;
      mkdirProcess.pendingFileName = newFileName;
      mkdirProcess.pendingContent = content;
      mkdirProcess.command = ["mkdir", "-p", root.plainVault];
      mkdirProcess.running = true;
    }
  }

  function deleteNote(fileName) {
    if (root.currentFileName === fileName) {
      root.currentFileName = "";
      root.currentTitle = "";
      root.currentContent = "";
    }
    deleteProcess.deletedFileName = fileName;
    deleteProcess.command = ["rm", "-f", root.plainVault + fileName];
    deleteProcess.running = true;
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    RowLayout {
      anchors.fill: parent
      anchors.margins: Style.marginM
      spacing: Style.marginM

      // ── SIDEBAR ──────────────────────────────────────────────────────────
      Rectangle {
        Layout.preferredWidth: 220 * Style.uiScaleRatio
        Layout.fillHeight: true
        color: Color.mSurfaceVariant
        radius: Style.radiusL

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Style.marginM
          spacing: Style.marginS

          // Sidebar header
          RowLayout {
            spacing: Style.marginS
            Layout.fillWidth: true

            NIcon { icon: "notebook"; pointSize: Style.fontSizeM }

            NText {
              text: pluginApi?.tr("panel.header.title") || "Notes"
              font.pointSize: Style.fontSizeM
              font.weight: Font.Medium
              color: Color.mOnSurface
              Layout.fillWidth: true
            }

            NIconButton {
              icon: "plus"
              tooltipText: pluginApi?.tr("panel.header.add_button") || "New Note"
              onClicked: root.createNote()
            }
          }

          // Divider
          Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Color.mOutlineVariant
            opacity: 0.5
          }

          // Empty state
          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.notesList.length === 0

            NText {
              text: "No notes yet"
              color: Color.mOnSurfaceVariant
              anchors.centerIn: parent
              font.pointSize: Style.fontSizeS
            }
          }

          // Notes list
          ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.notesList.length > 0
            clip: true

            ListView {
              id: notesListView
              model: root.notesList
              spacing: 2
              boundsBehavior: Flickable.StopAtBounds
              flickableDirection: Flickable.VerticalFlick

              delegate: Rectangle {
                width: ListView.view.width
                height: noteItemCol.implicitHeight + Style.marginS * 2
                color: modelData.fileName === root.currentFileName
                  ? Color.mPrimaryContainer
                  : (hovered ? Color.mHover : "transparent")
                radius: Style.radiusS

                property bool hovered: false

                MouseArea {
                  anchors.fill: parent
                  hoverEnabled: true
                  cursorShape: Qt.PointingHandCursor
                  onEntered: parent.hovered = true
                  onExited: parent.hovered = false
                  onClicked: root.openNote(modelData.fileName, modelData.title)
                }

                ColumnLayout {
                  id: noteItemCol
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.verticalCenter: parent.verticalCenter
                  anchors.leftMargin: Style.marginS
                  anchors.rightMargin: Style.marginS
                  spacing: 2

                  NText {
                    text: modelData.title
                    font.weight: modelData.fileName === root.currentFileName ? Font.SemiBold : Font.Normal
                    font.pointSize: Style.fontSizeS
                    color: modelData.fileName === root.currentFileName
                      ? Color.mOnPrimaryContainer
                      : Color.mOnSurface
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                  }

                  NText {
                    text: new Date(modelData.modifiedAt).toLocaleDateString()
                    font.pointSize: Style.fontSizeXS
                    color: modelData.fileName === root.currentFileName
                      ? Color.mOnPrimaryContainer
                      : Color.mOnSurfaceVariant
                    opacity: 0.8
                  }
                }
              }
            }
          }
        }
      }

      // ── EDITOR PANE ───────────────────────────────────────────────────────
      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Color.mSurfaceVariant
        radius: Style.radiusL

        // No note selected
        Item {
          anchors.fill: parent
          visible: root.currentFileName === "" && !root.isCreating

          NText {
            anchors.centerIn: parent
            text: "Select a note or create a new one"
            color: Color.mOnSurfaceVariant
            font.pointSize: Style.fontSizeM
          }
        }

        // Editor (always shown when a note is open or creating)
        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Style.marginM
          visible: root.currentFileName !== "" || root.isCreating
          spacing: Style.marginM

          // Toolbar
          RowLayout {
            spacing: Style.marginS
            Layout.fillWidth: true

            NTextInput {
              id: titleInput
              Layout.fillWidth: true
              placeholderText: pluginApi?.tr("panel.editor.title_placeholder") || "Note Title"
              text: root.currentTitle
              onTextChanged: root.currentTitle = text
            }

            // Saved indicator
            NText {
              text: root.isSaving
                ? (root.gitAutoPush ? "⟳ Pushing..." : "⟳ Saving...")
                : "✓ " + (root.gitAutoPush ? "Pushed" : "Saved")
              font.pointSize: Style.fontSizeS
              color: Color.mOnSurfaceVariant
              opacity: (root.isSaving || root.savedIndicatorVisible) ? 1.0 : 0.0
              Behavior on opacity { NumberAnimation { duration: 300 } }
            }

            NButton {
              text: pluginApi?.tr("panel.editor.save_button") || "Save"
              icon: "device-floppy"
              onClicked: root.saveNote(titleInput.text, contentArea.text)
            }

            NButton {
              text: pluginApi?.tr("panel.editor.delete_button") || "Delete"
              backgroundColor: Color.mError
              onClicked: root.deleteNote(root.currentFileName)
            }
          }

          // Editor area
          Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Color.mSurface
            radius: Style.radiusM

            ScrollView {
              anchors.fill: parent
              anchors.margins: Style.marginS

              TextArea {
                id: contentArea
                width: parent.width
                placeholderText: pluginApi?.tr("panel.editor.content_placeholder") || "Write your thoughts here..."
                placeholderTextColor: Color.mOnSurfaceVariant
                text: root.currentContent
                wrapMode: TextEdit.Wrap
                color: Color.mOnSurface
                font.pointSize: Style.fontSizeM
                font.family: "JetBrains Mono"
                background: null
                selectByMouse: true
              }
            }
          }
        }
      }
    }
  }
}
