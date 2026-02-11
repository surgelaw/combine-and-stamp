# 📚 Documentation Index

Welcome to the PDF Combine & Stamp project documentation! This index will help you find exactly what you need.

## 🚀 Start Here

**Brand new to this project?**
→ [`QUICKSTART.md`](QUICKSTART.md) - Get running in 5 minutes

**Want the big picture?**
→ [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md) - Complete overview

**Need to understand the architecture?**
→ [`ARCHITECTURE.md`](ARCHITECTURE.md) - Visual diagrams and flow charts

---

## 👨‍💻 For Developers

### Getting Started
| Document | What's Inside | When to Use |
|----------|---------------|-------------|
| [`QUICKSTART.md`](QUICKSTART.md) | 5-minute setup guide | Starting development |
| [`PROJECT_SETUP.md`](PROJECT_SETUP.md) | Detailed Xcode configuration | Configuring targets |
| [`configure_project.sh`](configure_project.sh) | Automated file checker | Verifying setup |

### Development
| Document | What's Inside | When to Use |
|----------|---------------|-------------|
| [`ARCHITECTURE.md`](ARCHITECTURE.md) | System diagrams | Understanding flow |
| Source Code | Implementation | Daily coding |
| [`test_extension.sh`](test_extension.sh) | Testing tools | Testing features |

### Building & Distribution
| Document | What's Inside | When to Use |
|----------|---------------|-------------|
| [`build.sh`](build.sh) | Build automation | Creating releases |
| [`CHECKLIST.md`](CHECKLIST.md) | Verification steps | Pre-release QA |

### Migration
| Document | What's Inside | When to Use |
|----------|---------------|-------------|
| [`MIGRATION_GUIDE.md`](MIGRATION_GUIDE.md) | Automator removal | Upgrading project |

---

## 👥 For End Users

### Installation & Usage
| Document | What's Inside | When to Use |
|----------|---------------|-------------|
| [`README.md`](README.md) | User guide | Installation & usage |

### Troubleshooting
| Document | What's Inside | When to Use |
|----------|---------------|-------------|
| [`README.md#troubleshooting`](README.md#troubleshooting) | Common issues | Extension not working |

---

## 📖 By Topic

### Architecture & Design
- **Overview**: [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md)
- **Visual Diagrams**: [`ARCHITECTURE.md`](ARCHITECTURE.md)
- **Component Details**: [`PROJECT_SETUP.md`](PROJECT_SETUP.md)

### Setup & Configuration
- **Quick Start**: [`QUICKSTART.md`](QUICKSTART.md)
- **Detailed Setup**: [`PROJECT_SETUP.md`](PROJECT_SETUP.md)
- **Verification**: [`configure_project.sh`](configure_project.sh)

### Building & Testing
- **Build Script**: [`build.sh`](build.sh)
- **Test Script**: [`test_extension.sh`](test_extension.sh)
- **Checklist**: [`CHECKLIST.md`](CHECKLIST.md)

### Migration
- **From Automator**: [`MIGRATION_GUIDE.md`](MIGRATION_GUIDE.md)
- **User Transition**: [`README.md`](README.md)

### Reference
- **All Documents**: This index
- **Source Code**: See file structure below

---

## 🗂️ File Structure Guide

### 📄 Documentation Files

```
├── INDEX.md                    ← You are here!
├── QUICKSTART.md               ← Start here for 5-min setup
├── IMPLEMENTATION_SUMMARY.md   ← Complete project overview
├── ARCHITECTURE.md             ← Visual diagrams & flow
├── PROJECT_SETUP.md            ← Detailed Xcode setup
├── MIGRATION_GUIDE.md          ← Remove Automator artifacts
├── CHECKLIST.md                ← Pre-release verification
├── README.md                   ← End user documentation
```

### 🔧 Helper Scripts

```
├── configure_project.sh        ← Check file structure
├── build.sh                    ← Build & sign app
├── test_extension.sh           ← Test extension
```

### 💻 Source Code

```
├── PDFCombineStamp/            ← Main App Target
│   ├── BatesStampApp.swift         • App entry point & delegate
│   ├── ContentView.swift           • Info view (when launched)
│   ├── BatesStampView.swift        • Options UI (legacy/CLI)
│   └── PDFCombineStamp.entitlements
│
├── PDFCombineStampExtension/   ← Extension Target
│   ├── ShareViewController.swift   • Extension entry point
│   ├── ExtensionView.swift         • Options UI
│   ├── Info.plist                  • Extension configuration
│   └── PDFCombineStampExtension.entitlements
│
├── Shared/                     ← Shared Code
│   └── PDFManager.swift            • PDF processing logic
│
└── PDFManager.swift            ← (Deprecated, use Shared/)
```

---

## 🎯 By User Role

### First-Time Developer

**Your Journey:**
1. Read: [`QUICKSTART.md`](QUICKSTART.md) (5 min)
2. Run: `./configure_project.sh` (verify files)
3. Follow: [`PROJECT_SETUP.md`](PROJECT_SETUP.md) (Xcode setup)
4. Test: `./test_extension.sh` (verify it works)
5. Reference: [`ARCHITECTURE.md`](ARCHITECTURE.md) (understand how it works)

**Time Required:** ~30 minutes

### Experienced Developer (New to Project)

**Your Journey:**
1. Skim: [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md) (overview)
2. Reference: [`ARCHITECTURE.md`](ARCHITECTURE.md) (understand design)
3. Configure: Use [`PROJECT_SETUP.md`](PROJECT_SETUP.md) as checklist
4. Build: `./build.sh --clean`
5. Test: `./test_extension.sh test`

**Time Required:** ~15 minutes

### Maintainer/Contributor

**Key Documents:**
- Architecture: [`ARCHITECTURE.md`](ARCHITECTURE.md)
- Setup: [`PROJECT_SETUP.md`](PROJECT_SETUP.md)
- Checklist: [`CHECKLIST.md`](CHECKLIST.md)
- Build: [`build.sh`](build.sh)

### Project Manager

**Key Documents:**
- Overview: [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md)
- User Docs: [`README.md`](README.md)
- Migration: [`MIGRATION_GUIDE.md`](MIGRATION_GUIDE.md)

### End User

**Key Documents:**
- Installation: [`README.md`](README.md)
- Troubleshooting: [`README.md#troubleshooting`](README.md#troubleshooting)

### DevOps/Release Engineer

**Key Documents:**
- Build: [`build.sh`](build.sh)
- Checklist: [`CHECKLIST.md`](CHECKLIST.md)
- Distribution: [`PROJECT_SETUP.md#distribution`](PROJECT_SETUP.md#distribution)

---

## 🔍 By Task

### "I need to..."

#### Set Up Development Environment
1. [`QUICKSTART.md`](QUICKSTART.md) - Quick setup
2. [`PROJECT_SETUP.md`](PROJECT_SETUP.md) - Detailed instructions
3. [`configure_project.sh`](configure_project.sh) - Verify setup

#### Understand the Architecture
1. [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md) - Overview
2. [`ARCHITECTURE.md`](ARCHITECTURE.md) - Diagrams & flow
3. Source code - Implementation details

#### Build the App
1. [`build.sh`](build.sh) - Automated building
2. [`PROJECT_SETUP.md#building`](PROJECT_SETUP.md#building) - Manual steps
3. [`CHECKLIST.md`](CHECKLIST.md) - Verification

#### Test the Extension
1. [`test_extension.sh`](test_extension.sh) - Testing tools
2. [`QUICKSTART.md#testing`](QUICKSTART.md#testing) - Quick tests
3. [`CHECKLIST.md#testing`](CHECKLIST.md#testing) - Complete tests

#### Prepare for Release
1. [`CHECKLIST.md`](CHECKLIST.md) - Complete checklist
2. [`build.sh`](build.sh) - Build signed version
3. [`PROJECT_SETUP.md#distribution`](PROJECT_SETUP.md#distribution) - Packaging

#### Remove Automator
1. [`MIGRATION_GUIDE.md`](MIGRATION_GUIDE.md) - Complete guide
2. [`IMPLEMENTATION_SUMMARY.md#migration`](IMPLEMENTATION_SUMMARY.md#migration) - Overview

#### Help End Users
1. [`README.md`](README.md) - User documentation
2. [`README.md#troubleshooting`](README.md#troubleshooting) - Common issues

#### Debug Issues
1. [`test_extension.sh check`](test_extension.sh) - Diagnostics
2. [`ARCHITECTURE.md`](ARCHITECTURE.md) - Understand flow
3. [`CHECKLIST.md#troubleshooting`](CHECKLIST.md#troubleshooting) - Common fixes

---

## 📱 Quick Commands Reference

### Setup
```bash
# Verify file structure
./configure_project.sh

# Make scripts executable (if needed)
chmod +x *.sh
```

### Building
```bash
# Development build
./build.sh --clean

# Signed release
./build.sh --clean --sign "Developer ID Application"

# Distribution package
./build.sh --clean --sign "Developer ID" --dmg
```

### Testing
```bash
# Interactive menu
./test_extension.sh

# Check status
./test_extension.sh check

# Create test files
./test_extension.sh test

# Reset extension cache
./test_extension.sh reset
```

### Troubleshooting
```bash
# Clean everything
rm -rf ~/Library/Developer/Xcode/DerivedData/PDFCombineStamp-*
./build.sh --clean

# Reset extension registration
/System/Library/CoreServices/pbs -flush
killall Finder

# Check extension status
pluginkit -m -v | grep PDFCombineStamp
```

---

## 🎓 Learning Path

### Beginner Path (New to macOS Extensions)

**Day 1: Understanding**
- [ ] Read [`README.md`](README.md) - See end-user perspective
- [ ] Read [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md) - Get overview
- [ ] Read [`ARCHITECTURE.md`](ARCHITECTURE.md) - Understand design

**Day 2: Setup**
- [ ] Follow [`QUICKSTART.md`](QUICKSTART.md) - 5-minute setup
- [ ] Work through [`PROJECT_SETUP.md`](PROJECT_SETUP.md) - Detailed configuration
- [ ] Run `./configure_project.sh` - Verify setup

**Day 3: Building & Testing**
- [ ] Use `./build.sh` - Build the app
- [ ] Use `./test_extension.sh` - Test functionality
- [ ] Review [`CHECKLIST.md`](CHECKLIST.md) - Understand QA

**Day 4: Deep Dive**
- [ ] Study source code - Understand implementation
- [ ] Read Apple's App Extension Guide
- [ ] Experiment with modifications

### Intermediate Path (Familiar with Extensions)

**Hour 1:**
- [ ] Skim [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md)
- [ ] Review [`ARCHITECTURE.md`](ARCHITECTURE.md)
- [ ] Check [`PROJECT_SETUP.md`](PROJECT_SETUP.md)

**Hour 2:**
- [ ] Set up project from [`QUICKSTART.md`](QUICKSTART.md)
- [ ] Build with `./build.sh`
- [ ] Test with `./test_extension.sh`

**Hour 3:**
- [ ] Explore source code
- [ ] Make test modifications
- [ ] Verify with [`CHECKLIST.md`](CHECKLIST.md)

### Advanced Path (Experienced Developer)

**15 Minutes:**
- [ ] Read [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md)
- [ ] Skim [`ARCHITECTURE.md`](ARCHITECTURE.md)
- [ ] Run `./configure_project.sh && ./build.sh && ./test_extension.sh`

---

## 🆘 Help Topics

### Extension Not Appearing
→ [`README.md#troubleshooting`](README.md#troubleshooting)
→ [`test_extension.sh reset`](test_extension.sh)

### Build Errors
→ [`CHECKLIST.md#build-errors`](CHECKLIST.md#build-errors)
→ [`PROJECT_SETUP.md#troubleshooting`](PROJECT_SETUP.md#troubleshooting)

### Code Signing Issues
→ [`PROJECT_SETUP.md#code-signing`](PROJECT_SETUP.md#code-signing)
→ [`build.sh`](build.sh)

### Understanding Architecture
→ [`ARCHITECTURE.md`](ARCHITECTURE.md)
→ [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md)

### Removing Automator
→ [`MIGRATION_GUIDE.md`](MIGRATION_GUIDE.md)

---

## 📊 Document Matrix

| Document | User | Dev | Setup | Build | Test | Arch | Ref |
|----------|:----:|:---:|:-----:|:-----:|:----:|:----:|:---:|
| README | ✓✓✓ | ✓ | | | | | ✓ |
| QUICKSTART | ✓ | ✓✓✓ | ✓✓✓ | ✓ | ✓ | | |
| IMPLEMENTATION_SUMMARY | ✓ | ✓✓✓ | ✓ | ✓ | | ✓✓ | ✓✓✓ |
| ARCHITECTURE | | ✓✓✓ | | | | ✓✓✓ | ✓✓ |
| PROJECT_SETUP | | ✓✓✓ | ✓✓✓ | ✓✓ | | ✓ | ✓✓✓ |
| MIGRATION_GUIDE | | ✓✓✓ | ✓✓ | | | | ✓ |
| CHECKLIST | | ✓✓✓ | ✓✓ | ✓✓✓ | ✓✓✓ | | ✓✓ |
| configure_project.sh | | ✓✓ | ✓✓✓ | | | | |
| build.sh | | ✓✓✓ | | ✓✓✓ | | | ✓ |
| test_extension.sh | | ✓✓✓ | ✓ | | ✓✓✓ | | |

**Legend:**
- ✓✓✓ = Essential
- ✓✓ = Very useful
- ✓ = Helpful
- (blank) = Not applicable

---

## 🔗 External Resources

### Apple Documentation
- [App Extension Programming Guide](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/)
- [Share Extension](https://developer.apple.com/documentation/foundation/nsextensioncontext)
- [App Sandbox](https://developer.apple.com/documentation/security/app_sandbox)
- [Code Signing](https://developer.apple.com/support/code-signing/)
- [Notarization](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)

### Related Technologies
- [PDFKit Documentation](https://developer.apple.com/documentation/pdfkit)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [AppKit Documentation](https://developer.apple.com/documentation/appkit)

---

## 📝 Document Summaries

### User-Facing

**[`README.md`](README.md)** - End user guide
- Installation instructions
- How to use the extension
- Troubleshooting common issues
- Support information

### Developer Getting Started

**[`QUICKSTART.md`](QUICKSTART.md)** - 5-minute setup
- Minimal steps to get running
- Quick commands
- Essential configuration
- Fast testing

**[`PROJECT_SETUP.md`](PROJECT_SETUP.md)** - Complete setup guide
- Detailed Xcode configuration
- Target setup instructions
- Entitlements explanation
- Code signing setup
- Distribution preparation

### Architecture & Design

**[`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md)** - Project overview
- What changed from Automator
- Architecture explanation
- File structure
- Key decisions
- Future enhancements

**[`ARCHITECTURE.md`](ARCHITECTURE.md)** - Visual reference
- System diagrams
- Flow charts
- Component interactions
- Data flow
- Security model

### Process & Quality

**[`CHECKLIST.md`](CHECKLIST.md)** - Verification steps
- Setup checklist
- Build checklist
- Testing checklist
- Pre-release checklist
- Distribution checklist

**[`MIGRATION_GUIDE.md`](MIGRATION_GUIDE.md)** - Automator removal
- Files to remove
- System cleanup
- Git cleanup
- User migration
- Rollback plan

### Automation

**[`configure_project.sh`](configure_project.sh)** - Setup helper
- Verify file structure
- Check requirements
- Quick diagnostics

**[`build.sh`](build.sh)** - Build automation
- Clean builds
- Code signing
- DMG creation
- Notarization

**[`test_extension.sh`](test_extension.sh)** - Testing tools
- Check installation
- Create test files
- Reset cache
- Diagnostics

---

## 🎯 Success Criteria

### Setup Complete
- [ ] All files from `./configure_project.sh` present
- [ ] Xcode project opens without errors
- [ ] Both targets build successfully
- [ ] Extension embedded in app bundle

### Development Ready
- [ ] Understands architecture from [`ARCHITECTURE.md`](ARCHITECTURE.md)
- [ ] Can build with `./build.sh`
- [ ] Can test with `./test_extension.sh`
- [ ] Debugger attaches to extension

### Release Ready
- [ ] All items in [`CHECKLIST.md`](CHECKLIST.md) completed
- [ ] Code signed correctly
- [ ] Tests pass on clean Mac
- [ ] Documentation updated

---

## 📞 Getting Help

1. **Check Documentation**
   - Start with this index
   - Follow links to relevant docs
   - Use search (Cmd+F) in documents

2. **Run Diagnostics**
   ```bash
   ./test_extension.sh check
   ```

3. **Review Checklist**
   - [`CHECKLIST.md`](CHECKLIST.md)

4. **Check Troubleshooting**
   - [`README.md#troubleshooting`](README.md#troubleshooting)
   - [`PROJECT_SETUP.md#troubleshooting`](PROJECT_SETUP.md#troubleshooting)

5. **Review Architecture**
   - [`ARCHITECTURE.md`](ARCHITECTURE.md) - Understand expected behavior

---

**Welcome to PDF Combine & Stamp! 🎉**

This index should help you find exactly what you need. Start with [`QUICKSTART.md`](QUICKSTART.md) if you're ready to dive in!
