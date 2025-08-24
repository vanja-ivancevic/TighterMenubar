# GitHub Release Guide for TighterMenubar v1.0

## Release Assets Created

The following files have been prepared for the GitHub release:

### Download Packages
1. **TighterMenubar-v1.0.dmg** (1.4 MB)
   - Traditional macOS disk image installer
   - Mount and drag to Applications folder
   - SHA256: `3ea1c595252eb368f29cd0f4f9f2c99dab1ede30586a4f10a35161e67d9e1f48`

2. **TighterMenubar-v1.0.zip** (1.0 MB)
   - Compressed app bundle
   - Extract and move to Applications folder
   - SHA256: `7229dbaad0110c0874c49852b2516623434875684e0b715d6e56b7742eb4c2fd`

### Additional Files
3. **TighterMenubar-v1.0-checksums.txt**
   - SHA256 checksums for integrity verification
   
4. **RELEASE_NOTES.md**
   - Detailed release notes and installation instructions

## Steps to Create GitHub Release

### 1. Navigate to GitHub Repository
Go to your TighterMenubar repository on GitHub.

### 2. Create New Release
1. Click on "Releases" in the right sidebar
2. Click "Create a new release"

### 3. Release Configuration
- **Tag version**: `v1.0`
- **Release title**: `TighterMenubar v1.0 - Initial Release`
- **Target**: `main` (or your default branch)

### 4. Release Description
Copy and paste the following markdown:

```markdown
# TighterMenubar v1.0 - Initial Release

A simple macOS utility for customizing menu bar item spacing and padding to create a more compact menu bar layout.

## 🚀 Features

- **Adjustable Spacing**: Control the gap between menu bar items (levels 1-10)
- **Adjustable Padding**: Control the clickable area around each menu bar item (levels 1-10)
- **Real-time Preview**: See changes before applying them
- **Host-specific Settings**: Different configurations for different Macs
- **Automatic Font Detection**: Scales properly with system font sizes
- **Easy Reset**: Restore to system defaults with one click

## 📋 System Requirements

- macOS 13.5 or later
- Apple Silicon (ARM64) or Intel Mac
- Administrator privileges (required to modify system defaults)

## 📦 Download Options

Choose either download option below:

### DMG Package (Recommended)
- **File**: `TighterMenubar-v1.0.dmg` (1.4 MB)
- **Installation**: Mount the disk image and drag TighterMenubar.app to your Applications folder
- **SHA256**: `3ea1c595252eb368f29cd0f4f9f2c99dab1ede30586a4f10a35161e67d9e1f48`

### ZIP Archive
- **File**: `TighterMenubar-v1.0.zip` (1.0 MB)
- **Installation**: Extract and move TighterMenubar.app to your Applications folder
- **SHA256**: `7229dbaad0110c0874c49852b2516623434875684e0b715d6e56b7742eb4c2fd`

## 🔧 Installation & Usage

1. Download either the DMG or ZIP file above
2. Install TighterMenubar.app to your Applications folder
3. Launch the app and adjust your preferred settings
4. Click "Apply & Logout" to activate the changes

## ⚠️ Important Notes

- Changes require a logout/login cycle to take full effect
- The app modifies system defaults using `NSStatusItemSpacing` and `NSStatusItemSelectionPadding`
- Settings are stored per-host, so different Macs can have different configurations
- Use "Restore Defaults" to revert to original macOS behavior

## 🔐 Security & Code Signing

- **Code Signed**: Yes (Apple Development certificate)
- **Hardened Runtime**: Enabled
- **Sandboxed**: Yes
- **Bundle Identifier**: `vanja.TighterMenubar`

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

## 🐛 Issues & Support

Found a bug or have a feature request? Please [open an issue](../../issues).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for discussion.

---

**Full Changelog**: This is the initial release of TighterMenubar.
```

### 5. Upload Release Assets
Drag and drop or click "Attach binaries" to upload:
1. `TighterMenubar-v1.0.dmg`
2. `TighterMenubar-v1.0.zip`
3. `TighterMenubar-v1.0-checksums.txt`

### 6. Release Options
- ✅ Check "Set as the latest release"
- ✅ Check "Create a discussion for this release" (optional)
- ❌ Leave "Set as a pre-release" unchecked

### 7. Publish Release
Click "Publish release" to make it live.

## Post-Release Actions

### Update README.md
Add installation instructions pointing to the latest release:

```markdown
## Installation

Download the latest release from [GitHub Releases](https://github.com/your-username/TighterMenubar/releases/latest).

Choose either:
- **TighterMenubar-v1.0.dmg** - Traditional macOS installer
- **TighterMenubar-v1.0.zip** - Compressed app bundle
```

### Social Media/Announcements
Consider announcing the release on:
- Twitter/X
- Reddit (r/macOS, r/MacApps)
- Hacker News
- Product Hunt

## File Verification

Users can verify download integrity using:
```bash
shasum -a 256 TighterMenubar-v1.0.dmg
shasum -a 256 TighterMenubar-v1.0.zip
```

Compare with checksums in `TighterMenubar-v1.0-checksums.txt`.