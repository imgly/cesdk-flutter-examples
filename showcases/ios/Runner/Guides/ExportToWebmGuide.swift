import imgly_editor

// highlight-import-swift
import IMGLYEditor
import IMGLYEngine
import SwiftUI

// highlight-import-swift

func useWebmVideoEditor() {
  // highlight-closure-swift
  IMGLYEditorPlugin.builderClosure = { preset, _ in
    if preset == .video {
      webmVideoEditor()
    } else {
      EditorBuilder.design()
    }
  }
  // highlight-closure-swift
}

// highlight-editor-swift
private func webmVideoEditor() -> EditorBuilder.Builder {
  EditorBuilder.custom { settings, _, _, result in
    WebmVideoEditor(settings: settings, result: result)
  }
}

// The `custom` closure is not isolated to the main actor, so the editor is built in `body`, which is.
private struct WebmVideoEditor: View {
  let settings: EditorSettings
  let result: EditorBuilder.EditorBuilderResult

  var body: some View {
    NavigationView {
      Editor(EngineSettings(
        license: settings.license,
        userID: settings.userId,
        baseURL: URL(string: settings.baseUri),
      ))
      .imgly.configuration {
        VideoEditorConfiguration { builder in
          builder.onCreate { engine, _ in
            if let createScene = try OnCreate.loadFromSettings(settings) {
              try await VideoEditorConfiguration.defaultOnCreate(createScene: createScene)(engine)
            } else {
              try await VideoEditorConfiguration.defaultOnCreate()(engine)
            }
          }
          builder.onExport { engine, eventHandler, _ in
            do {
              let editorResult = try await OnExport.exportVideo(engine, eventHandler, .webm)
              result(.success(editorResult))
            } catch {
              if error is CancellationError {
                return
              }
              result(.failure(error))
            }
          }
        }
        ModalEditorConfiguration(result: result)
      }
    }
    .navigationViewStyle(.stack)
  }
}

// highlight-editor-swift
