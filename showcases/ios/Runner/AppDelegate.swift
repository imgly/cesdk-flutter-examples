import Flutter
import imgly_editor
import IMGLYEditor
import IMGLYEngine
import SwiftUI
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  /// A typealias for `EditorBuilder.EditorBuilderResult` for convenient usage.
  typealias EditorBuilderResult = EditorBuilder.EditorBuilderResult

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
  ) -> Bool {
    // swiftlint:disable:next force_cast
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "native_cleanup", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "cleanUp" {
        if let windowScene = UIApplication.shared.connectedScenes
          .filter({ $0.activationState == .foregroundActive })
          .first as? UIWindowScene {
          if let rootViewController = windowScene.windows
            .filter(\.isKeyWindow).first?.rootViewController {
            rootViewController.dismiss(animated: true, completion: {
              result(true)
            })
          } else {
            result(nil)
          }
        } else {
          result(nil)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)

    // Apply the custom editor.
    assignCustomEditor()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Assings the custom editors.
  private func assignCustomEditor() {
    /// Returns a custom or default editor based on the metadata.
    /// - Parameters:
    ///   - defaultEditor: The default editor.
    ///   - customEditor: The custom editor.
    ///   - metadata: The metadata used to determine which editor to use.
    /// - Returns: The corresponding `EditorBuilder.Builder`.
    func defaultOrCustomEditor(
      defaultEditor: @escaping EditorBuilder.Builder,
      customEditor: @escaping EditorBuilder.Builder,
      metadata: [String: Any]?,
    ) -> EditorBuilder.Builder {
      if let enabled = metadata?["custom"] as? Bool, enabled == true {
        customEditor
      } else {
        defaultEditor
      }
    }

    IMGLYEditorPlugin.builderClosure = { preset, metadata in
      switch preset {
      case .postcard:
        defaultOrCustomEditor(
          defaultEditor: EditorBuilder.postcard(),
          customEditor: EditorBuilder.custom { settings, _, _, result in
            CustomPostcardEditor(settings: settings, result: result)
          },
          metadata: metadata,
        )
      case .photo:
        defaultOrCustomEditor(
          defaultEditor: EditorBuilder.photo(),
          customEditor: EditorBuilder.custom { settings, _, _, result in
            CustomPhotoEditor(settings: settings, result: result)
          },
          metadata: metadata,
        )
      case .video:
        defaultOrCustomEditor(
          defaultEditor: EditorBuilder.video(),
          customEditor: EditorBuilder.custom { settings, _, _, result in
            CustomVideoEditor(settings: settings, result: result)
          },
          metadata: metadata,
        )
      case .design:
        defaultOrCustomEditor(
          defaultEditor: EditorBuilder.design(),
          customEditor: EditorBuilder.custom { settings, _, _, result in
            CustomDesignEditor(settings: settings, result: result)
          },
          metadata: metadata,
        )
      case .apparel:
        defaultOrCustomEditor(
          // NOTE: This custom editor is only used for UITests.
          // By default, simply use `EditorBuilder.apparel()` instead.
          defaultEditor: EditorBuilder.custom { settings, _, _, result in
            ApparelEditorForUITests(settings: settings, result: result)
          },
          customEditor: EditorBuilder.custom { settings, _, _, result in
            CustomApparelEditor(settings: settings, result: result)
          },
          metadata: metadata,
        )
      case nil:
        EditorBuilder.custom { settings, _, _, result in
          CustomDesignEditor(settings: settings, result: result)
        }
      }
    }
  }
}

// MARK: - Custom Editors

/// An extension  containig the custom editor implementations.
extension AppDelegate {
  /// Derives `EngineSettings` for a given `EditorSettings`.
  /// - Parameters:
  ///   - settings: The `EditorSettings` to derive the settings from.
  /// - Returns: The derived `EngineSettings`.
  private static func engineSettings(for settings: EditorSettings) -> EngineSettings {
    EngineSettings(license: settings.license, userID: settings.userId, baseURL: URL(string: settings.baseUri))
  }

  /// A custom design editor.
  private struct CustomDesignEditor: View {
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      NavigationView {
        Editor(engineSettings(for: settings))
          .imgly.configuration {
            DesignEditorConfiguration { builder in
              builder.onCreate { engine, _ in
                if let createScene = try OnCreate.loadFromSettings(settings) {
                  try await DesignEditorConfiguration.defaultOnCreate(createScene: createScene)(engine)
                } else {
                  try await DesignEditorConfiguration.defaultOnCreate()(engine)
                }
                try engine.asset.addSource(UnsplashAssetSource(host: Secrets.unsplashHost))
              }
              builder.onExport { engine, _, _ in
                do {
                  let editorResult = try await OnExport.export(engine, .png)
                  result(.success(editorResult))
                } catch {
                  result(.failure(error))
                }
              }
            }
            ModalEditorConfiguration(result: result)
          }
      }.navigationViewStyle(.stack)
    }
  }

  /// A custom apparel editor.
  private struct CustomApparelEditor: View {
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      NavigationView {
        Editor(engineSettings(for: settings))
          .imgly.configuration {
            ApparelEditorConfiguration { builder in
              builder.onCreate { engine, _ in
                if let createScene = try OnCreate.loadFromSettings(settings) {
                  try await ApparelEditorConfiguration.defaultOnCreate(createScene: createScene)(engine)
                } else {
                  try await ApparelEditorConfiguration.defaultOnCreate()(engine)
                }
                try engine.asset.addSource(UnsplashAssetSource(host: Secrets.unsplashHost))

                // This is only needed for UITests.
                try engine.editor.setSettingBool("showBuildVersion", value: false)
              }
              builder.onExport { engine, _, _ in
                do {
                  let editorResult = try await OnExport.export(engine, .pdf)
                  result(.success(editorResult))
                } catch {
                  result(.failure(error))
                }
              }
            }
            ModalEditorConfiguration(result: result)
          }
      }.navigationViewStyle(.stack)
    }
  }

  /// A custom photo editor.
  private struct CustomPhotoEditor: View {
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      NavigationView {
        Editor(engineSettings(for: settings))
          .imgly.configuration {
            PhotoEditorConfiguration { builder in
              builder.onCreate { engine, _ in
                if let createScene = try OnCreate.loadFromSettings(settings) {
                  try await PhotoEditorConfiguration.defaultOnCreate(createScene: createScene)(engine)
                } else {
                  try await PhotoEditorConfiguration.defaultOnCreate()(engine)
                }
                try engine.asset.addSource(UnsplashAssetSource(host: Secrets.unsplashHost))
              }
              builder.onExport { engine, _, _ in
                do {
                  let editorResult = try await OnExport.export(engine, .png)
                  result(.success(editorResult))
                } catch {
                  result(.failure(error))
                }
              }
            }
            ModalEditorConfiguration(result: result)
          }
      }.navigationViewStyle(.stack)
    }
  }

  /// A custom video editor.
  private struct CustomVideoEditor: View {
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      NavigationView {
        Editor(engineSettings(for: settings))
          .imgly.configuration {
            VideoEditorConfiguration { builder in
              builder.onCreate { engine, _ in
                if let createScene = try OnCreate.loadFromSettings(settings) {
                  try await VideoEditorConfiguration.defaultOnCreate(createScene: createScene)(engine)
                } else {
                  try await VideoEditorConfiguration.defaultOnCreate()(engine)
                }
                try engine.asset.addSource(UnsplashAssetSource(host: Secrets.unsplashHost))
              }
              builder.onExport { engine, eventHandler, _ in
                do {
                  let editorResult = try await OnExport.exportVideo(engine, eventHandler, .mp4)
                  result(.success(editorResult))
                } catch {
                  if error is CancellationError { return }
                  result(.failure(error))
                }
              }
            }
            ModalEditorConfiguration(result: result)
          }
      }.navigationViewStyle(.stack)
    }
  }

  /// A custom postcard editor.
  private struct CustomPostcardEditor: View {
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      NavigationView {
        Editor(engineSettings(for: settings))
          .imgly.configuration {
            PostcardEditorConfiguration { builder in
              builder.onCreate { engine, _ in
                if let createScene = try OnCreate.loadFromSettings(settings) {
                  try await PostcardEditorConfiguration.defaultOnCreate(createScene: createScene)(engine)
                } else {
                  try await PostcardEditorConfiguration.defaultOnCreate()(engine)
                }
                try engine.asset.addSource(UnsplashAssetSource(host: Secrets.unsplashHost))
              }
              builder.onExport { engine, _, _ in
                do {
                  let editorResult = try await OnExport.export(engine, .pdf)
                  result(.success(editorResult))
                } catch {
                  result(.failure(error))
                }
              }
            }
            ModalEditorConfiguration(result: result)
          }
      }.navigationViewStyle(.stack)
    }
  }

  /// A custom apparel editor for UITests.
  private struct ApparelEditorForUITests: View {
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      NavigationView {
        Editor(engineSettings(for: settings))
          .imgly.configuration {
            ApparelEditorConfiguration { builder in
              builder.onCreate { engine, _ in
                if let createScene = try OnCreate.loadFromSettings(settings) {
                  try await ApparelEditorConfiguration.defaultOnCreate(createScene: createScene)(engine)
                } else {
                  try await ApparelEditorConfiguration.defaultOnCreate()(engine)
                }

                // This is only needed for UITests.
                try engine.editor.setSettingBool("showBuildVersion", value: false)
              }
              builder.onExport { engine, _, _ in
                do {
                  let editorResult = try await OnExport.export(engine, .pdf)
                  result(.success(editorResult))
                } catch {
                  result(.failure(error))
                }
              }
            }
            ModalEditorConfiguration(result: result)
          }
      }.navigationViewStyle(.stack)
    }
  }
}
