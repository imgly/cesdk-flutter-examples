import Flutter
import imgly_editor
import IMGLYApparelEditor
import IMGLYDesignEditor
import IMGLYPhotoEditor
import IMGLYPostcardEditor
import IMGLYVideoEditor
import SwiftUI
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  /// A typealias for `EditorBuilder.EditorBuilderResult` for convenient usage.
  typealias EditorBuilderResult = EditorBuilder.EditorBuilderResult

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
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
      metadata: [String: Any]?
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
          metadata: metadata
        )
      case .photo:
        defaultOrCustomEditor(
          defaultEditor: EditorBuilder.photo(),
          customEditor: EditorBuilder.custom { settings, _, _, result in
            CustomPhotoEditor(settings: settings, result: result)
          },
          metadata: metadata
        )
      case .video:
        defaultOrCustomEditor(
          defaultEditor: EditorBuilder.video(),
          customEditor: EditorBuilder.custom { settings, _, _, result in
            CustomVideoEditor(settings: settings, result: result)
          },
          metadata: metadata
        )
      case .design:
        defaultOrCustomEditor(
          defaultEditor: EditorBuilder.design(),
          customEditor: EditorBuilder.custom { settings, _, _, result in
            CustomDesignEditor(settings: settings, result: result)
          },
          metadata: metadata
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
          metadata: metadata
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
    if let url = URL(string: settings.sceneBaseUri) {
      EngineSettings(license: settings.license, userID: settings.userId, baseURL: url)
    } else {
      EngineSettings(license: settings.license, userID: settings.userId)
    }
  }

  /// A custom design editor.
  private struct CustomDesignEditor: View {
    @Environment(\.dismiss) private var dismiss
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      ModalEditor {
        DesignEditor(engineSettings(for: settings))
          .imgly.onCreate { engine in
            try await OnCreate.load(settings, defaultSource: DesignEditor.defaultScene)(engine)
            try engine.asset.addSource(UnsplashAssetSource(host: Secrets.unsplashHost))
          }
          .imgly.onExport { engine, _ in
            do {
              let editorResult = try await OnExport.export(engine, .png)
              result(.success(editorResult))
            } catch {
              result(.failure(error))
            }
          }
          .imgly.assetLibrary {
            DefaultAssetLibrary()
              .images {
                AssetLibrarySource.image(.title("Unsplash"), source: .init(id: UnsplashAssetSource.id))
                DefaultAssetLibrary.images
              }
          }
      } onDismiss: { cancelled in
        if cancelled {
          result(.success(nil))
          dismiss()
        } else {
          result(.failure("Export failed."))
        }
      }
    }
  }

  /// A custom apparel editor.
  private struct CustomApparelEditor: View {
    @Environment(\.dismiss) private var dismiss
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      ModalEditor {
        ApparelEditor(engineSettings(for: settings))
          .imgly.onCreate { engine in
            try await OnCreate.load(settings, defaultSource: ApparelEditor.defaultScene)(engine)
            try engine.asset.addSource(UnsplashAssetSource(host: Secrets.unsplashHost))

            // This is only needed for UITests.
            try engine.editor.setSettingBool("showBuildVersion", value: false)
          }
          .imgly.onExport { engine, _ in
            do {
              let editorResult = try await OnExport.export(engine, .pdf)
              result(.success(editorResult))
            } catch {
              result(.failure(error))
            }
          }
          .imgly.assetLibrary {
            DefaultAssetLibrary()
              .images {
                AssetLibrarySource.image(.title("Unsplash"), source: .init(id: UnsplashAssetSource.id))
                DefaultAssetLibrary.images
              }
          }
      } onDismiss: { cancelled in
        if cancelled {
          result(.success(nil))
          dismiss()
        } else {
          result(.failure("Export failed."))
        }
      }
    }
  }

  /// A custom photo editor.
  private struct CustomPhotoEditor: View {
    @Environment(\.dismiss) private var dismiss
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      ModalEditor {
        PhotoEditor(engineSettings(for: settings))
          .imgly.onCreate { engine in
            try await OnCreate.load(settings, defaultSource: PhotoEditor.defaultImage)(engine)
            try engine.asset.addSource(UnsplashAssetSource(host: Secrets.unsplashHost))
          }
          .imgly.onExport { engine, _ in
            do {
              let editorResult = try await OnExport.export(engine, .png)
              result(.success(editorResult))
            } catch {
              result(.failure(error))
            }
          }
          .imgly.assetLibrary {
            DefaultAssetLibrary()
              .images {
                AssetLibrarySource.image(.title("Unsplash"), source: .init(id: UnsplashAssetSource.id))
                DefaultAssetLibrary.images
              }
          }
      } onDismiss: { cancelled in
        if cancelled {
          result(.success(nil))
          dismiss()
        } else {
          result(.failure("Export failed."))
        }
      }
    }
  }

  /// A custom video editor.
  private struct CustomVideoEditor: View {
    @Environment(\.dismiss) private var dismiss
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      ModalEditor {
        VideoEditor(engineSettings(for: settings))
          .imgly.onCreate { engine in
            try await OnCreate.load(settings, defaultSource: VideoEditor.defaultScene)(engine)
            try engine.asset.addSource(UnsplashAssetSource(host: Secrets.unsplashHost))
          }
          .imgly.onExport { engine, eventHandler in
            do {
              let editorResult = try await OnExport.exportVideo(engine, eventHandler, .mp4)
              result(.success(editorResult))
            } catch {
              result(.failure(error))
            }
          }
          .imgly.assetLibrary {
            DefaultAssetLibrary()
              .images {
                AssetLibrarySource.image(.title("Unsplash"), source: .init(id: UnsplashAssetSource.id))
                DefaultAssetLibrary.images
              }
          }
      } onDismiss: { cancelled in
        if cancelled {
          result(.success(nil))
          dismiss()
        } else {
          result(.failure("Export failed."))
        }
      }
    }
  }

  /// A custom postcard editor.
  private struct CustomPostcardEditor: View {
    @Environment(\.dismiss) private var dismiss
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      ModalEditor {
        PostcardEditor(engineSettings(for: settings))
          .imgly.onCreate { engine in
            try await OnCreate.load(
              settings,
              settings.source?.type ?? .image,
              defaultSource: PostcardEditor.defaultScene
            )(engine)
            try engine.asset.addSource(UnsplashAssetSource(host: Secrets.unsplashHost))
          }
          .imgly.onExport { engine, _ in
            do {
              let editorResult = try await OnExport.export(engine, .pdf)
              result(.success(editorResult))
            } catch {
              result(.failure(error))
            }
          }
          .imgly.assetLibrary {
            DefaultAssetLibrary()
              .images {
                AssetLibrarySource.image(.title("Unsplash"), source: .init(id: UnsplashAssetSource.id))
                DefaultAssetLibrary.images
              }
          }
      } onDismiss: { cancelled in
        if cancelled {
          result(.success(nil))
          dismiss()
        } else {
          result(.failure("Export failed."))
        }
      }
    }
  }

  /// A custom apparel editor.
  private struct ApparelEditorForUITests: View {
    @Environment(\.dismiss) private var dismiss
    private let settings: EditorSettings
    private let result: EditorBuilderResult

    init(settings: EditorSettings, result: @escaping EditorBuilderResult) {
      self.settings = settings
      self.result = result
    }

    var body: some View {
      ModalEditor {
        ApparelEditor(engineSettings(for: settings))
          .imgly.onCreate { engine in
            try await OnCreate.load(settings, defaultSource: ApparelEditor.defaultScene)(engine)

            // This is only needed for UITests.
            try engine.editor.setSettingBool("showBuildVersion", value: false)
          }
          .imgly.onExport { engine, _ in
            do {
              let editorResult = try await OnExport.export(engine, .pdf)
              result(.success(editorResult))
            } catch {
              result(.failure(error))
            }
          }
      } onDismiss: { cancelled in
        if cancelled {
          result(.success(nil))
          dismiss()
        } else {
          result(.failure("Export failed."))
        }
      }
    }
  }
}
