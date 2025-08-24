import Foundation
import AppKit

/// A struct to hold the calculated layout values for the preview.
struct MenuBarLayoutValues {
    let hStackSpacing: CGFloat
    let itemPadding: CGFloat
}

/// A dedicated engine for calculating menu bar layout parameters based on empirical research.
struct MenuBarLayoutEngine {
    
    /// Holds the OS-specific baseline layout constants.
    private struct OSVersionConstants {
        let baseSpacing: CGFloat
        let basePadding: CGFloat
        let defaultFontSize: CGFloat
        let intrinsicButtonPadding: CGFloat
    }
    
    /// OS version-specific constants with improved estimates
    /// Level 1 should be much tighter, level 10 stays the same, interpolate between
    private static let osConstants: [Int: OSVersionConstants] = [
        14: OSVersionConstants(  // macOS Sonoma
            baseSpacing: 1.0,      // Much tighter baseline
            basePadding: 0.5,      // Much tighter baseline
            defaultFontSize: 14.0,
            intrinsicButtonPadding: 1.0  // More realistic intrinsic padding
        ),
        15: OSVersionConstants(  // macOS Sequoia
            baseSpacing: 1.0,      // Much tighter baseline
            basePadding: 0.5,      // Much tighter baseline
            defaultFontSize: 14.0,
            intrinsicButtonPadding: 1.0  // More realistic intrinsic padding
        )
    ]
    
    /// Gets the appropriate constants for the current macOS version
    private static func constantsForCurrentOS() -> OSVersionConstants {
        let majorVersion = ProcessInfo.processInfo.operatingSystemVersion.majorVersion
        return osConstants[majorVersion] ?? osConstants[15]! // Fallback to Sequoia
    }
    
    /// Calculates the required SwiftUI layout values based on system settings.
    /// Uses progressive scaling: tight at level 1, current estimates at level 10
    /// - Parameters:
    ///   - spacingValue: The integer value for NSStatusItemSpacing (1-10)
    ///   - paddingValue: The integer value for NSStatusItemSelectionPadding (1-10)
    ///   - currentFontSize: The current menu bar font size in points
    /// - Returns: MenuBarLayoutValues with calculated spacing and padding
    static func calculateLayout(
        spacingValue: Int,
        paddingValue: Int,
        currentFontSize: CGFloat
    ) -> MenuBarLayoutValues {
        let os = constantsForCurrentOS()
        
        // Font scaling factor based on research findings
        let fontScaleFactor = currentFontSize / os.defaultFontSize
        
        // Progressive scaling: level 1 = tight, level 10 = current estimate
        // Interpolate between tight start and current level 10 estimates
        let spacingAtLevel10: CGFloat = 10.0  // Keep current level 10 estimate
        let paddingAtLevel10: CGFloat = 8.0   // Keep current level 10 estimate
        
        // Calculate progressive multipliers (0.0 to 1.0 range for values 1-10)
        let normalizedSpacing = CGFloat(spacingValue - 1) / 9.0  // 0.0 at level 1, 1.0 at level 10
        let normalizedPadding = CGFloat(paddingValue - 1) / 9.0  // 0.0 at level 1, 1.0 at level 10
        
        // Progressive spacing: tight at level 1, full at level 10
        let progressiveSpacing = os.baseSpacing + (normalizedSpacing * spacingAtLevel10 * fontScaleFactor)
        
        // Progressive padding: tight at level 1, full at level 10
        let progressivePadding = os.basePadding + (normalizedPadding * paddingAtLevel10 * fontScaleFactor)
        let totalItemPadding = os.intrinsicButtonPadding + progressivePadding
        
        return MenuBarLayoutValues(
            hStackSpacing: max(0, progressiveSpacing),
            itemPadding: max(0, totalItemPadding)
        )
    }
    
    /// Provides a calibration mechanism for fine-tuning the constants
    /// This would be used by a calibration feature to measure actual system behavior
    static func updateConstants(
        spacingMultiplier: CGFloat,
        paddingMultiplier: CGFloat,
        for osVersion: Int
    ) {
        // In a full implementation, this would update stored constants
        // For now, this serves as a placeholder for the calibration system
    }
}