import SwiftUI
import AppKit

/// A view that accurately previews a single menu bar item based on empirical research.
struct MenuBarItemPreview: View {
    let symbolName: String
    let paddingValue: CGFloat
    
    @Binding var hoveredSymbol: String?

    // Constants derived from empirical measurement (research findings)
    private let highlightCornerRadius: CGFloat = 4.0
    private let highlightColor = Color(nsColor: NSColor.white.withAlphaComponent(0.25))
    private let hoverAnimationDuration = 0.1

    var body: some View {
        let isHovered = hoveredSymbol == symbolName
        
        Image(systemName: symbolName)
            .padding(.horizontal, paddingValue)
            .padding(.vertical, 2)  // Minimal, realistic vertical padding
            .background(
                RoundedRectangle(cornerRadius: highlightCornerRadius)
                    .fill(isHovered ? highlightColor : Color.clear)
            )
            .onHover { isHovering in
                withAnimation(.easeIn(duration: hoverAnimationDuration)) {
                    hoveredSymbol = isHovering ? symbolName : nil
                }
            }
            .accessibilityLabel(Text(symbolName))
    }
}

/// A view that displays a full preview of the menu bar layout using research-based calculations.
struct MenuBarPreview: View {
    @Binding var spacing: Double
    @Binding var selectionPadding: Double
    @ObservedObject var fontManager: SystemFontManager
    
    @State private var hoveredSymbol: String? = nil
    
    private let symbolNames = [
        "wifi", "battery.100.bolt", "speaker.wave.2.fill",
        "magnifyingglass", "command.circle", "music.note"
    ]

    var body: some View {
        // Calculate layout values using the research-based engine
        let layoutValues = MenuBarLayoutEngine.calculateLayout(
            spacingValue: Int(spacing),
            paddingValue: Int(selectionPadding),
            currentFontSize: fontManager.menuBarFontSize
        )
        
        return GroupBox("Preview") {
            HStack(spacing: layoutValues.hStackSpacing) {
                ForEach(symbolNames, id: \.self) { name in
                    MenuBarItemPreview(
                        symbolName: name,
                        paddingValue: layoutValues.itemPadding,
                        hoveredSymbol: $hoveredSymbol
                    )
                    .font(.system(size: fontManager.menuBarFontSize))
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 22)  // More realistic menu bar working height
        }
    }
}