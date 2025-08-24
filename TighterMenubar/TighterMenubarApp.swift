import SwiftUI
import os.log

@main
struct TighterMenubarApp: App {
    private let logger = Logger(subsystem: "com.tightermenubar.app", category: "TighterMenubarApp")
    
    init() {
        logger.info("TighterMenubar app initializing")
        logger.debug("App bundle identifier: \(Bundle.main.bundleIdentifier ?? "unknown")")
        logger.debug("App version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown")")
    }
    
    var body: some Scene {
        Settings {
            MenuBarSettingsView()
                .frame(width: 420)
                .onAppear {
                    logger.info("Settings view appeared")
                }
        }
    }
}
