import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    configureTableOrientationChannel()
  }

  private func configureTableOrientationChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let channel = FlutterMethodChannel(
      name: "biks/table_orientation",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "allowTableRotation":
        self?.setSupportedOrientations(.allButUpsideDown)
        result(nil)
      case "forceTableLandscape":
        self?.setSupportedOrientations(.landscape)
        result(nil)
      case "restorePortrait":
        self?.setSupportedOrientations(.portrait)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func setSupportedOrientations(_ orientations: UIInterfaceOrientationMask) {
    OrientationLock.supportedOrientations = orientations

    if #available(iOS 16.0, *), let windowScene = window?.windowScene {
      window?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
      windowScene.requestGeometryUpdate(
        .iOS(interfaceOrientations: orientations)
      )
    } else {
      UIViewController.attemptRotationToDeviceOrientation()
    }
  }
}
