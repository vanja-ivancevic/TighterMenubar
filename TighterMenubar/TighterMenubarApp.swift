import SwiftUI
import os.log

@main
struct TighterMenubarApp: App {
    private let logger = Logger(subsystem: "com.tightermenubar.app", category: "TighterMenubarApp")
    
    init() {
        logger.info("TighterMenubar app initializing")
        logger.debug("App bundle identifier: \(Bundle.main.bundleIdentifier ?? "unknown")")
        logger.debug("App version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown")")
        logger.debug("Process info: \(ProcessInfo.processInfo)")
        logger.debug("Main bundle path: \(Bundle.main.bundlePath)")
        
        // Log system information
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        logger.info("Running on macOS \(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)")
        
        // Log app launch context
        logger.info("App launched with arguments: \(CommandLine.arguments)")
        logger.info("Environment variables count: \(ProcessInfo.processInfo.environment.count)")
    }
    
    var body: some Scene {
        logger.info("Creating app scenes")
        
        return Group {
            // Main window that shows on app launch
            WindowGroup("TighterMenubar") {
                ContentView()
                    .frame(width: 420)
                    .onAppear {
                        logger.info("Main window content view appeared")
                    }
                    .onDisappear {
                        logger.info("Main window content view disappeared")
                    }
            }
            .windowStyle(.hiddenTitleBar)
            .windowResizability(.contentSize)
            .defaultPosition(.center)
            
            // Settings window (accessible via menu)
            Settings {
                MenuBarSettingsView()
                    .frame(width: 420)
                    .onAppear {
                        logger.info("Settings view appeared")
                    }
                    .onDisappear {
                        logger.info("Settings view disappeared")
                    }
            }
        }
    }
}

// Main content view for the primary window
struct ContentView: View {
    private let logger = Logger(subsystem: "com.tightermenubar.app", category: "ContentView")
    
    var body: some View {
        MenuBarSettingsView()
            .onAppear {
                logger.info("ContentView appeared - main window is now visible")
                
                // Log window information in a simple way
                let windowCount = NSApplication.shared.windows.count
                logger.debug("Total windows: \(windowCount)")
                
                if let window = NSApplication.shared.windows.first {
                    logger.debug("Main window is visible: \(window.isVisible)")
                    logger.debug("Main window is key: \(window.isKeyWindow)")
                } else {
                    logger.warning("No main window found")
                }
            }
    }
}

#Preview {
    ContentView()
}
