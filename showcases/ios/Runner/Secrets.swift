class Secrets {
  static var unsplashHost: String {
    if let defines = Bundle.main.infoDictionary?["DART_DEFINES"] as? String,
       let unsplashHost = defines.components(separatedBy: ",").first,
       let unsplashHostData = Data(base64Encoded: unsplashHost),
       let decoded = String(data: unsplashHostData, encoding: .utf8) {
      let decodedComponents = decoded.components(separatedBy: "=")
      guard decodedComponents.count > 1, let key = decodedComponents.first,
            key == "CESDK_UNSPLASH_HOST" else { return "" }
      return decodedComponents[1]
    }
    return ""
  }
}
