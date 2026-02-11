# Architecture Diagram

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         macOS System                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────┐         ┌─────────────────────────────┐ │
│  │  Finder.app      │         │  PDFCombineStamp.app        │ │
│  │                  │         │  ┌─────────────────────────┐│ │
│  │  User selects    │────────▶│  │  Main App              ││ │
│  │  files and       │  invoke │  │  • BatesStampApp       ││ │
│  │  right-clicks    │         │  │  • ContentView         ││ │
│  │                  │         │  │  • BatesStampView      ││ │
│  │  ┌────────────┐  │         │  └─────────────────────────┘│ │
│  │  │Quick Actions│ │         │                              │ │
│  │  │           │  │         │  ┌─────────────────────────┐│ │
│  │  │ Combine   │──┼────────▶│  │  Extension (appex)     ││ │
│  │  │ PDFs and  │  │  files  │  │  • ShareViewController ││ │
│  │  │ Stamp     │  │         │  │  • ExtensionView       ││ │
│  │  └────────────┘  │         │  └─────────────────────────┘│ │
│  └──────────────────┘         │           │                  │ │
│                               │           │ uses             │ │
│                               │           ▼                  │ │
│                               │  ┌─────────────────────────┐│ │
│                               │  │  Shared/PDFManager      ││ │
│                               │  │  • combineAndStamp()    ││ │
│                               │  │  • isSupported()        ││ │
│                               │  └─────────────────────────┘│ │
│                               └─────────────────────────────┘ │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## File Flow

```
User Action:
1. Select files in Finder
2. Right-click → Quick Actions → "Combine PDFs and Stamp"

System Response:
3. macOS invokes extension with NSExtensionContext
4. ShareViewController receives file URLs via NSItemProvider
5. ExtensionView displays options UI
6. User configures and clicks "Combine and Stamp"
7. PDFManager.shared.combineAndStamp() processes files
8. Output PDF saved to source directory
9. NSWorkspace reveals file in Finder
10. Extension completes request
```

## Component Interaction

```
┌─────────────────────────────────────────────────────────────────┐
│ ShareViewController                                             │
│  │                                                               │
│  ├─▶ loadView()           Create NSView                        │
│  ├─▶ viewDidLoad()        Setup hosting controller             │
│  │    │                                                          │
│  │    └─▶ extractURLsFromExtensionContext()                    │
│  │         │                                                     │
│  │         ├─▶ extensionContext.inputItems                     │
│  │         ├─▶ NSItemProvider loading                          │
│  │         └─▶ completion with [URL]                           │
│  │                                                               │
│  └─▶ ExtensionView                                              │
│       │                                                          │
│       ├─▶ Display UI                                            │
│       │    ├─ Warnings (unsupported files, size)               │
│       │    ├─ Options (Bates prefix, start number)             │
│       │    └─ Buttons (Cancel, Combine)                        │
│       │                                                          │
│       ├─▶ processFiles()                                        │
│       │    │                                                     │
│       │    └─▶ PDFManager.shared.combineAndStamp()             │
│       │         │                                                │
│       │         ├─▶ For each URL:                              │
│       │         │    ├─ Load PDF or image                      │
│       │         │    ├─ Add to destination document            │
│       │         │    └─ Apply Bates stamp if enabled           │
│       │         │                                                │
│       │         └─▶ Write combined PDF to outputURL            │
│       │                                                          │
│       └─▶ onComplete(outputURL)                                │
│            │                                                     │
│            └─▶ completeRequest() or cancelRequest()            │
└─────────────────────────────────────────────────────────────────┘
```

## Bundle Structure

```
PDFCombineStamp.app/
├── Contents/
│   ├── Info.plist
│   ├── MacOS/
│   │   └── PDFCombineStamp                   ← Main executable
│   ├── Resources/
│   │   ├── Assets.car
│   │   └── ...
│   ├── _CodeSignature/
│   │   └── CodeResources
│   ├── PlugIns/
│   │   └── PDFCombineStampExtension.appex/   ← Extension
│   │       ├── Contents/
│   │       │   ├── Info.plist                (Extension config)
│   │       │   ├── MacOS/
│   │       │   │   └── PDFCombineStampExtension
│   │       │   └── _CodeSignature/
│   │       │       └── CodeResources
│   │       └── ...
│   └── ...
```

## Data Flow

```
┌─────────────────┐
│ User selects    │
│ files in Finder │
└────────┬────────┘
         │
         │ Right-click → Quick Actions
         │
         ▼
┌──────────────────────────────────────────┐
│ macOS Extension System                   │
│  • Checks NSExtensionActivationRule      │
│  • Creates NSExtensionContext            │
│  • Wraps file URLs in NSItemProviders    │
└────────┬─────────────────────────────────┘
         │
         │ Launches extension
         │
         ▼
┌──────────────────────────────────────────┐
│ ShareViewController                      │
│  • Receives NSExtensionContext           │
│  • Extracts URLs from item providers     │
│  • Passes to ExtensionView               │
└────────┬─────────────────────────────────┘
         │
         │ URLs: [file:///Users/.../doc1.pdf, ...]
         │
         ▼
┌──────────────────────────────────────────┐
│ ExtensionView                            │
│  • Validates file types                  │
│  • Shows warnings                        │
│  • Collects user options:                │
│    - Bates prefix                        │
│    - Starting number                     │
│    - Enable/disable stamping             │
└────────┬─────────────────────────────────┘
         │
         │ User clicks "Combine and Stamp"
         │
         ▼
┌──────────────────────────────────────────┐
│ PDFManager.combineAndStamp()             │
│  Input:                                  │
│   • urls: [URL]                          │
│   • prefix: String                       │
│   • startingNumber: Int                  │
│   • batesEnabled: Bool                   │
│   • outputURL: URL                       │
│                                          │
│  Processing:                             │
│   For each URL:                          │
│     1. Load PDF or convert image to PDF  │
│     2. For each page:                    │
│        a. Create stamped page            │
│        b. Add to destination document    │
│        c. Increment counter              │
│   3. Write combined PDF                  │
│                                          │
│  Output:                                 │
│   Combined_<timestamp>.pdf               │
└────────┬─────────────────────────────────┘
         │
         │ Returns outputURL
         │
         ▼
┌──────────────────────────────────────────┐
│ ExtensionView.onComplete()               │
│  • Calls NSWorkspace to reveal in Finder │
│  • Completes extension request           │
└────────┬─────────────────────────────────┘
         │
         │
         ▼
┌──────────────────────────────────────────┐
│ Finder shows combined PDF                │
└──────────────────────────────────────────┘
```

## Security Model

```
┌─────────────────────────────────────────────────────────────────┐
│ App Sandbox                                                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Main App (PDFCombineStamp)                                      │
│ ┌─────────────────────────────────────────────────────────────┐│
│ │ Entitlements:                                               ││
│ │  • app-sandbox = true                                       ││
│ │  • files.user-selected.read-write = true                    ││
│ │  • files.downloads.read-write = true                        ││
│ │                                                              ││
│ │ Can access:                                                  ││
│ │  ✓ User-selected files (via NSOpenPanel)                    ││
│ │  ✓ Downloads folder                                         ││
│ │  ✗ Arbitrary file system locations                          ││
│ └─────────────────────────────────────────────────────────────┘│
│                                                                 │
│ Extension (PDFCombineStampExtension)                            │
│ ┌─────────────────────────────────────────────────────────────┐│
│ │ Entitlements:                                               ││
│ │  • inherit = true  (inherits parent's entitlements)         ││
│ │  • app-sandbox = true                                       ││
│ │  • files.user-selected.read-write = true                    ││
│ │  • files.downloads.read-write = true                        ││
│ │                                                              ││
│ │ Can access:                                                  ││
│ │  ✓ Files provided by Finder (automatically granted)         ││
│ │  ✓ Output directory (if it's the source directory)          ││
│ │  ✓ Desktop folder (explicit entitlement)                    ││
│ │  ✗ Other arbitrary locations                                ││
│ └─────────────────────────────────────────────────────────────┘│
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Build Process

```
┌─────────────────────────────────────────────────────────────────┐
│ Xcode Build                                                     │
└─────────────────────────────────────────────────────────────────┘
         │
         ├─▶ Build Main App Target
         │    │
         │    ├─ Compile sources:
         │    │   • BatesStampApp.swift
         │    │   • ContentView.swift
         │    │   • BatesStampView.swift
         │    │   • Shared/PDFManager.swift  (linked to this target)
         │    │
         │    ├─ Link frameworks:
         │    │   • SwiftUI
         │    │   • PDFKit
         │    │   • AppKit
         │    │
         │    └─▶ PDFCombineStamp (executable)
         │
         ├─▶ Build Extension Target
         │    │
         │    ├─ Compile sources:
         │    │   • ShareViewController.swift
         │    │   • ExtensionView.swift
         │    │   • Shared/PDFManager.swift  (linked to this target)
         │    │
         │    ├─ Link frameworks:
         │    │   • SwiftUI
         │    │   • PDFKit
         │    │   • AppKit
         │    │
         │    └─▶ PDFCombineStampExtension.appex
         │
         ├─▶ Embed Extension in Main App
         │    │
         │    └─ Copy PDFCombineStampExtension.appex
         │       to PDFCombineStamp.app/Contents/PlugIns/
         │
         └─▶ Code Sign
              │
              ├─ Sign Extension first:
              │   codesign --sign "Developer ID" \
              │     --entitlements Extension.entitlements \
              │     PDFCombineStamp.app/Contents/PlugIns/*.appex
              │
              └─ Sign Main App:
                  codesign --sign "Developer ID" \
                    --entitlements App.entitlements \
                    PDFCombineStamp.app
```

## Extension Registration

```
┌─────────────────────────────────────────────────────────────────┐
│ First Launch Sequence                                           │
└─────────────────────────────────────────────────────────────────┘

1. User launches PDFCombineStamp.app
         │
         ▼
2. LaunchServices detects embedded extension
         │
         ▼
3. pluginkit registers extension with system
         │
         ▼
4. Extension metadata cached:
   • Bundle ID: com.yourcompany.PDFCombineStamp.Extension
   • Type: com.apple.share-services
   • Activation rule: Files (max 999)
   • Display name: "Combine PDFs and Stamp"
         │
         ▼
5. Finder rebuilds Services/Quick Actions menu
         │
         ▼
6. Extension now appears in Finder's Quick Actions

Note: May require logout/login for full registration
```

## Comparison: Old vs New

```
┌───────────────────────────────┬───────────────────────────────┐
│ Automator (Old)               │ Native Extension (New)        │
├───────────────────────────────┼───────────────────────────────┤
│ User Action:                  │ User Action:                  │
│  1. Install .app              │  1. Install .app              │
│  2. Install .workflow         │  2. Launch once               │
│  3. Grant permissions         │  3. Done!                     │
│                               │                               │
│ Architecture:                 │ Architecture:                 │
│  App ← (separate) → Workflow  │  App → Embedded Extension     │
│                               │                               │
│ Location:                     │ Location:                     │
│  ~/Library/Services/          │  Inside .app bundle           │
│                               │                               │
│ Registration:                 │ Registration:                 │
│  Manual double-click          │  Automatic on first launch    │
│                               │                               │
│ Sandboxing:                   │ Sandboxing:                   │
│  Limited                      │  Full App Sandbox             │
│                               │                               │
│ Distribution:                 │ Distribution:                 │
│  2 files to manage            │  1 file (.app)                │
│                               │                               │
│ Updates:                      │ Updates:                      │
│  Update both separately       │  Update app (extension auto)  │
│                               │                               │
│ Debugging:                    │ Debugging:                    │
│  Difficult, limited tools     │  Full Xcode support           │
└───────────────────────────────┴───────────────────────────────┘
```

---

## Key Points

### Shared Code
- `Shared/PDFManager.swift` must be in **both** target memberships
- Must use `public` visibility for cross-target access
- Compiled separately for each target (not a framework)

### Bundle IDs
- Must follow pattern: `parent.Extension`
- Extension inherits parent's sandbox permissions
- Both must be signed with same certificate

### Extension Lifecycle
- Launched on-demand by system
- Process may be killed when inactive
- Should complete work quickly
- UI should be lightweight

### File Access
- Extension receives URLs via NSExtensionContext
- Files are automatically accessible (Finder provides access)
- Output must be in accessible location (source dir or Desktop)
- Can't access arbitrary file system locations

---

This architecture provides a native, secure, and maintainable solution for PDF combining and stamping directly from Finder.
