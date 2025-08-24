# TighterMenubar v1.0 Release Notes

## What's New

TighterMenubar v1.0 is the initial release of this macOS utility that allows you to customize menu bar item spacing and padding for a more compact menu bar layout.

## Features

- **Adjustable Spacing**: Control the gap between menu bar items (levels 1-10)
- **Adjustable Padding**: Control the clickable area around each menu bar item (levels 1-10)
- **Real-time Preview**: See changes before applying them
- **Host-specific Settings**: Different configurations for different Macs
- **Automatic Font Detection**: Scales properly with system font sizes
- **Easy Reset**: Restore to system defaults with one click

## System Requirements

- macOS 13.5 or later
- Apple Silicon (ARM64) or Intel Mac
- Administrator privileges (required to modify system defaults)

## Installation

1. Download either `TighterMenubar-v1.0.dmg` or `TighterMenubar-v1.0.zip`
2. If using DMG: Mount the disk image and drag TighterMenubar.app to your Applications folder
3. If using ZIP: Extract and move TighterMenubar.app to your Applications folder
4. Launch the app and adjust your preferred settings
5. Click "Apply & Logout" to activate the changes

## Important Notes

- Changes require a logout/login cycle to take full effect
- The app modifies system defaults using `NSStatusItemSpacing` and `NSStatusItemSelectionPadding`
- Settings are stored per-host, so different Macs can have different configurations
- Use "Restore Defaults" to revert to original macOS behavior

## Download Options

- **DMG Package**: `TighterMenubar-v1.0.dmg` (1.4 MB) - Traditional macOS installer
- **ZIP Archive**: `TighterMenubar-v1.0.zip` (1.0 MB) - Compressed app bundle

## Technical Details

- **Bundle Identifier**: `vanja.TighterMenubar`
- **Version**: 1.0 (Build 1)
- **Architecture**: Universal (ARM64 optimized)
- **Code Signed**: Yes (Apple Development certificate)
- **Hardened Runtime**: Enabled
- **Sandboxed**: Yes

## License

MIT License - See LICENSE file for details.

## Support

For issues, feature requests, or contributions, please visit the [GitHub repository](https://github.com/your-username/TighterMenubar).