import Foundation
import UIKit
import FabricSDK

struct AppConfig {
    let defaultSpaceURL: String

    static func load() -> AppConfig {
        guard let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let defaultSpaceURL = plist["DefaultSpaceURL"] as? String else {
            return AppConfig(defaultSpaceURL: "")
        }

        return AppConfig(defaultSpaceURL: defaultSpaceURL)
    }

    func makeWebViewConfig(spaceURL: URL, userIdToken: String) -> FabricWebViewConfig {
        FabricWebViewConfig(
            url: spaceURL,
            userIdToken: userIdToken,
            userLanguagePreferences: Locale.current.identifier.replacingOccurrences(of: "_", with: "-"),
            webViewDomains: ["accounts.google.com"],
            onCustomScheme: { url, scheme in
                // Filter out internal/system schemes that shouldn't show alerts
                let systemSchemes = ["about", "data", "file", "blob"]
                if systemSchemes.contains(scheme.lowercased()) {
                    return false  // Let system handle these
                }
                
                // Show alert for actual custom schemes (tel:, mailto:, app-specific, etc.)
                let alert = UIAlertController(
                    title: "Custom Scheme Detected",
                    message: "Scheme: \(scheme)\nURL: \(url.absoluteString)",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                // Get the current window's root view controller
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first,
                   let rootViewController = window.rootViewController {
                    rootViewController.present(alert, animated: true)
                }
                
                // Return true to indicate we handled it (show alert, block navigation)
                return true
            }
        )
    }
}
