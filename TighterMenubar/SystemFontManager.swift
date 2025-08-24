import Foundation
import AppKit
import Combine
import os.log

/// Manages and provides the system menu bar font size, updating reactively to system changes.
/// This class is an ObservableObject, allowing SwiftUI views to subscribe to its changes.
class SystemFontManager: ObservableObject {
    
    /// Published property that holds the current menu bar font size.
    /// SwiftUI views observing this manager will automatically update when this value changes.
    @Published var menuBarFontSize: CGFloat
    
    /// Holds the subscription to the NotificationCenter publisher.
    /// This ensures the subscription is retained for the lifetime of the object.
    private var cancellable: AnyCancellable?
    
    private let logger = Logger(subsystem: "com.tightermenubar.app", category: "SystemFontManager")

    init() {
        // Set the initial font size upon creation.
        // NSFont.menuBarFont(ofSize: 0) returns the system's default menu bar font.
        self.menuBarFontSize = NSFont.menuBarFont(ofSize: 0).pointSize
        logger.info("SystemFontManager initialized with font size: \(self.menuBarFontSize, privacy: .public)")
        
        // --- ARCHITECTURAL IMPROVEMENT ---
        // Replace inefficient Timer-based polling with an efficient, event-driven Combine publisher.
        // This subscription listens for system-wide font changes via NSApplication.didChangeScreenParametersNotification
        // which is triggered when display settings change, including font size changes.
        // The code inside `.sink` only runs when the notification is actually posted by the system,
        // resulting in zero CPU usage when there are no font changes.
        cancellable = NotificationCenter.default
           .publisher(for: NSApplication.didChangeScreenParametersNotification)
           .sink { [weak self] _ in
                // When the notification is received, call the update function.
                // Using [weak self] prevents retain cycles.
                self?.updateFontSize()
            }
        
        logger.info("Successfully subscribed to NSApplication.didChangeScreenParametersNotification for live font updates.")
    }
    
    deinit {
        // Although the sink captures self weakly, it's good practice to explicitly
        // cancel the subscription when the object is deinitialized.
        cancellable?.cancel()
        logger.info("SystemFontManager deinitializing - cancelling notification subscription.")
    }

    /// Updates the `menuBarFontSize` property if it has changed from the current system value.
    private func updateFontSize() {
        let currentSize = NSFont.menuBarFont(ofSize: 0).pointSize
        
        if currentSize != menuBarFontSize {
            logger.info("System font size changed from \(self.menuBarFontSize, privacy: .public) to \(currentSize, privacy: .public). Updating.")
            
            // Dispatch the update to the main thread, as it will trigger a UI refresh.
            DispatchQueue.main.async {
                self.menuBarFontSize = currentSize
                self.logger.debug("Published font size updated on main queue.")
            }
        }
    }
}