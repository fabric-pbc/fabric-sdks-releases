import SwiftUI
import FabricSDK

struct ContentView: View {
    private let appConfig: AppConfig
    @State private var spaceURL: String
    @State private var userIdToken = ""
    @State private var webViewConfig: FabricWebViewConfig?

    init() {
        let appConfig = AppConfig.load()
        self.appConfig = appConfig
        _spaceURL = State(initialValue: appConfig.defaultSpaceURL)
    }

    var body: some View {
        VStack(spacing: 0) {
            DemoBannerView()

            if let webViewConfig {
                FabricWebView(config: webViewConfig)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.bottom)
            } else {
                SessionEntryView(spaceURL: $spaceURL, userIdToken: $userIdToken) {
                    let trimmedURL = spaceURL.trimmingCharacters(in: .whitespacesAndNewlines)
                    let trimmedToken = userIdToken.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard let url = URL(string: trimmedURL) else {
                        return
                    }

                    webViewConfig = appConfig.makeWebViewConfig(spaceURL: url, userIdToken: trimmedToken)
                }
            }
        }
    }
}

struct DemoButton: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(color)
            .cornerRadius(10)
    }
}

struct SessionEntryView: View {
    @Binding var spaceURL: String
    @Binding var userIdToken: String
    let onApply: () -> Void

    private var isApplyDisabled: Bool {
        let trimmedURL = spaceURL.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedToken = userIdToken.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedToken.isEmpty || URL(string: trimmedURL) == nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Space URL")
                .font(.headline)

            TextField("https://example.com/space/name", text: $spaceURL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.URL)
                .textContentType(.URL)
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(uiColor: .separator), lineWidth: 1)
                )

            Text("JWT ID Token")
                .font(.headline)

            TextEditor(text: $userIdToken)
                .font(.system(.body, design: .monospaced))
                .frame(minHeight: 180)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(uiColor: .separator), lineWidth: 1)
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            Button(action: onApply) {
                DemoButton(text: "Apply Session", color: .blue)
            }
            .disabled(isApplyDisabled)
            .opacity(isApplyDisabled ? 0.5 : 1)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .systemBackground))
    }
}

// MARK: - Simple Banner (matches Android demo style)
struct DemoBannerView: View {
    var body: some View {
        HStack {
            Text("Fabric SDK Demo")
                .font(.headline)
            Spacer()
            Button("Reset Consent") {
                UserDefaults.standard.removeObject(forKey: "fabric_sdk_consent_v1")
                print("Cleared persisted consent (fabric_sdk_consent_v1)")
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
