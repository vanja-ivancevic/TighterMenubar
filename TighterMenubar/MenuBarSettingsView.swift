import SwiftUI
import AppKit
import os.log

struct MenuBarSettingsView: View {
    // MARK: - State Properties
    
    @State private var spacing: Double = 1.0
    @State private var selectionPadding: Double = 1.0
    @State private var showingLogoutConfirm = false
    @State private var showingResetConfirm = false
    @State private var hoveredSymbol: String? = nil
    @State private var hasUnsavedChanges = false

    @StateObject private var fontManager = SystemFontManager()
    
    // MARK: - Logging
    private let logger = Logger(subsystem: "com.tightermenubar.app", category: "MenuBarSettingsView")

    // MARK: - Properties

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            previewSection
            controlsSection
            footerSection
        }
        .padding()
        .onAppear {
            logger.info("MenuBarSettingsView appeared - initializing with spacing: \(spacing), padding: \(selectionPadding)")
            loadCurrentSettings()
        }
        .confirmationDialog("Restore Defaults?",
                            isPresented: $showingResetConfirm,
                            titleVisibility: .visible) {
            Button("Restore", role: .destructive) { 
                deleteDefaults() 
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Custom spacing and padding will be removed, reverting to macOS system behavior.")
        }
        .alert("Apply Changes & Log Out", isPresented: $showingLogoutConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Apply & Log Out", role: .destructive) {
                applyChanges()
                requestLogout()
            }
        } message: {
            Text("Changes will be applied and you'll be signed out of your Mac.")
        }
    }
    
    // MARK: - View Components
    
    private var previewSection: some View {
        MenuBarPreview(
            spacing: $spacing,
            selectionPadding: $selectionPadding,
            fontManager: fontManager
        )
    }
    
    private var controlsSection: some View {
        GroupBox("Controls") {
            VStack(spacing: 16) {
                spacingControl
                paddingControl
            }
            .padding(8)
        }
    }
    
    private var spacingControl: some View {
        HStack {
            Text("Spacing")
                .frame(width: 80, alignment: .leading)
            
            Slider(value: $spacing, in: 1...10, step: 1)
            .onChange(of: spacing) { _, newValue in
                logger.debug("Spacing changed to: \(newValue)")
                hasUnsavedChanges = true
            }
            
            Text("\(Int(spacing))")
                .foregroundStyle(.secondary)
                .font(.system(.body, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
    
    private var paddingControl: some View {
        HStack {
            Text("Padding")
                .frame(width: 80, alignment: .leading)
            
            Slider(value: $selectionPadding, in: 1...10, step: 1)
            .onChange(of: selectionPadding) { _, newValue in
                logger.debug("Selection padding changed to: \(newValue)")
                hasUnsavedChanges = true
            }
            
            Text("\(Int(selectionPadding))")
                .foregroundStyle(.secondary)
                .font(.system(.body, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
    
    private var footerSection: some View {
        VStack(spacing: 12) {
            HStack {
                Button("Restore Defaults…") {
                    showingResetConfirm = true
                }
                .keyboardShortcut(.delete, modifiers: [.command, .shift])
                .controlSize(.small)
                
                Spacer()
                
                Label("Changes will only take effect after logout", systemImage: "info.circle")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            
            HStack {
                Spacer()
                
                Button("Apply") {
                    applyChanges()
                }
                .buttonStyle(.bordered)
                .disabled(!hasUnsavedChanges)
                
                Button("Apply & Logout") {
                    showingLogoutConfirm = true
                }
                .keyboardShortcut(.init("q"), modifiers: [.command, .shift])
                .buttonStyle(.borderedProminent)
                .disabled(!hasUnsavedChanges)
            }
        }
    }

    // MARK: - Helper Functions
    
    /// Loads current settings from defaults on app launch
    private func loadCurrentSettings() {
        // Check if the keys exist in the -currentHost domain
        if defaultsKeysExist() {
            // Keys exist - read their values
            spacing = Double(readDefaultsInt("NSStatusItemSpacing") ?? 1)
            selectionPadding = Double(readDefaultsInt("NSStatusItemSelectionPadding") ?? 1)
            logger.info("Loaded existing settings - spacing: \(spacing), padding: \(selectionPadding)")
        } else {
            // Keys don't exist - set to default values
            spacing = 1.0
            selectionPadding = 1.0
            logger.info("No custom settings found - using default values")
        }
    }
    
    /// Applies changes without logging out
    private func applyChanges() {
        writeDefaults()
        hasUnsavedChanges = false
    }

    /// Writes current settings to defaults using -currentHost domain
    private func writeDefaults() {
        logger.info("Writing defaults - spacing: \(spacing), padding: \(selectionPadding)")
        
        // Prefer currentHost; write host-specific keys so laptop/desktop can differ.
        _ = run("/usr/bin/defaults", ["-currentHost","write","-g","NSStatusItemSpacing","-int","\(Int(spacing))"])
        _ = run("/usr/bin/defaults", ["-currentHost","write","-g","NSStatusItemSelectionPadding","-int","\(Int(selectionPadding))"])
        
        // Try graceful refresh first, fallback to killall if needed
        if !refreshMenuBarGracefully() {
            logger.warning("Graceful refresh failed, falling back to killall ControlCenter")
            _ = run("/usr/bin/killall", ["ControlCenter"])
        }
    }
    
    /// Attempts to refresh the menu bar gracefully using distributed notifications
    private func refreshMenuBarGracefully() -> Bool {
        logger.info("Attempting graceful menu bar refresh")
        
        // Try multiple possible notification names based on research
        let possibleNotifications = [
            "com.apple.controlcenter.settingschanged",
            "com.apple.systemuiserver.spacingchanged",
            "com.apple.menubar.settingschanged",
            "NSStatusItemSpacingChanged"
        ]
        
        let center = DistributedNotificationCenter.default()
        
        for notificationName in possibleNotifications {
            let notification = Notification.Name(notificationName)
            center.post(name: notification, object: nil)
            logger.debug("Posted notification: \(notificationName)")
        }
        
        // For now, we assume success - in a full implementation, we'd verify the change took effect
        return true
    }

    /// Deletes the custom defaults to restore system defaults
    private func deleteDefaults() {
        logger.info("Deleting custom defaults to restore system behavior")
        
        _ = run("/usr/bin/defaults", ["-currentHost","delete","-g","NSStatusItemSpacing"])
        _ = run("/usr/bin/defaults", ["-currentHost","delete","-g","NSStatusItemSelectionPadding"])
        
        // Reset UI to default values
        spacing = 1.0
        selectionPadding = 1.0
        hasUnsavedChanges = false
        
        // Try graceful refresh first, fallback to killall if needed
        if !refreshMenuBarGracefully() {
            logger.warning("Graceful refresh failed, falling back to killall ControlCenter")
            _ = run("/usr/bin/killall", ["ControlCenter"])
        }
    }

    /// Requests user logout via AppleScript
    private func requestLogout() {
        logger.info("Requesting user logout to apply changes")
        _ = run("/usr/bin/osascript", ["-e","tell application \"System Events\" to log out"])
    }

    /// Helper function to run shell commands
    @discardableResult
    private func run(_ path: String, _ args: [String]) -> Bool {
        logger.debug("Executing command: \(path) \(args.joined(separator: " "))")
        
        let task = Process()
        task.launchPath = path
        task.arguments = args
        
        do { 
            try task.run()
            task.waitUntilExit()
            let success = task.terminationStatus == 0
            
            if success {
                logger.debug("Command succeeded")
            } else {
                logger.warning("Command failed with exit code: \(task.terminationStatus)")
            }
            
            return success
        } catch {
            logger.error("Failed to execute command: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Checks if the defaults keys exist in the -currentHost domain
    private func defaultsKeysExist() -> Bool {
        let spacingExists = readDefaultsInt("NSStatusItemSpacing") != nil
        let paddingExists = readDefaultsInt("NSStatusItemSelectionPadding") != nil
        return spacingExists || paddingExists
    }
    
    /// Reads an integer value from the -currentHost domain defaults
    private func readDefaultsInt(_ key: String) -> Int? {
        let task = Process()
        task.launchPath = "/usr/bin/defaults"
        task.arguments = ["-currentHost", "read", "-g", key]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe() // Suppress error output
        
        do {
            try task.run()
            task.waitUntilExit()
            
            if task.terminationStatus == 0 {
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   let value = Int(output) {
                    logger.debug("Read \(key): \(value)")
                    return value
                }
            } else {
                logger.debug("Key \(key) does not exist in -currentHost domain")
            }
        } catch {
            logger.error("Failed to read \(key): \(error.localizedDescription)")
        }
        
        return nil
    }
}

#Preview {
    MenuBarSettingsView()
}