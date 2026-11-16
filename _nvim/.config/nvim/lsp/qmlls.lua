return {
  cmd = { "qmlls", "-I", "/usr/lib/qt6/qml" },
  cmd_env = {
    QML_IMPORT_PATH = "/usr/lib/qt6/qml",
    QML2_IMPORT_PATH = "/usr/lib/qt6/qml",
  },
  filetypes = { "qml", "qmljs" },
  root_markers = { ".qmlls.ini", "CMakeLists.txt", ".git" },
}
