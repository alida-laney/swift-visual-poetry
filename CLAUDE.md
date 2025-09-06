# Swift Visual Poetry - iOS Photo Editor

A powerful Instagram/SnapChat-style photo editor built with SwiftUI featuring drag-to-position text overlays, inline editing, and professional styling controls.

## 🎯 Project Overview
Creating an iPhone app that provides professional photo editing capabilities with a focus on text overlays and visual storytelling.

## ✨ Current Features

### Phase 1: Foundation ✅
- **iOS App Structure**: Clean SwiftUI architecture with tab navigation
- **Camera Integration**: Device camera with simulator fallback to photo library
- **Gallery Picker**: Modern PhotosUI integration for selecting photos
- **Project Setup**: Proper .gitignore, documentation, and GitHub integration

### Phase 2: Core Editing ✅
- **Photo Editing Canvas**: Full-screen editing interface with dimmed controls
- **Drag-to-Position Text**: Smooth touch gestures for text positioning
- **Instagram-Style Inline Editing**: No modal popups - edit directly over photo
- **Individual Text Properties**: Each text overlay maintains its own styling

### Text Styling System ✅
- **9 Color Options**: White, Black, Red, Blue, Green, Yellow, Purple, Orange, Pink
- **Dynamic Font Sizing**: 16-64pt range with live slider preview
- **5 Font Weights**: Light, Regular, Medium, Bold, Heavy
- **Text Alignment**: Left, Center, Right with visual indicators
- **Multiline Support**: Natural line breaks with up to 8 lines

### User Experience ✅
- **Live Preview**: WYSIWYG text editing with real-time styling
- **Visual Feedback**: Opacity changes during drag operations
- **Clean Interface**: Borderless text input, horizontal color picker
- **Intuitive Gestures**: Tap to edit, drag to move
- **Professional Flow**: Camera/Gallery → Edit → Style → Position

## 🛠 Technical Architecture

### Core Components
- `PhotoEditorView`: Main editing canvas with overlay management
- `InlineTextEditingView`: Instagram-style text editor with controls
- `DraggableTextView`: Handles text positioning and gesture recognition
- `TextOverlay`: Data model for individual text properties
- `CameraCoordinator` & `PhotoPickerCoordinator`: Media selection interfaces

### Key Technologies
- **SwiftUI**: Modern declarative UI framework
- **PhotosUI**: Modern photo selection (iOS 14+)
- **UIImagePickerController**: Camera integration with fallbacks
- **AVFoundation**: Camera permissions and capabilities
- **Gesture Recognition**: Drag gestures with simultaneous handling

## 📱 Supported Platforms
- **iOS 14.0+**: Required for PhotosUI framework
- **iPhone/iPad**: Universal app support
- **Simulator Testing**: Photo library fallback for development

## 🔧 Development Setup

### Required Info.plist Entries
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to the camera to take photos for editing.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to your photo library to select photos for editing.</string>
```

### Testing Commands
- **Build**: `⌘+B` in Xcode
- **Run**: `⌘+R` in Xcode  
- **Test Gestures**: Use simulator or physical device

## 📋 Roadmap

### Next Phase: Smart Features 🔄
- **Smart Alignment Guides**: PowerPoint-style snap-to alignment
- **Local Photo Storage**: Save edited photos to app gallery
- **Personal Gallery**: View and manage saved creations
- **Export Functionality**: Save to Photos app or share

### Future Enhancements 📝
- **Pinch-to-Resize**: Intuitive gesture-based text scaling
- **UI Polish**: Animations, haptics, and visual improvements
- **Performance**: Optimization for large images and multiple text overlays
- **Advanced Features**: Rotation, shadows, gradients

### Potential Features 💡
- **Text Templates**: Pre-designed text layouts
- **Background Effects**: Blur, darken, highlight areas behind text
- **Font Library**: Custom font support beyond system fonts
- **Emoji Support**: Enhanced emoji picker and sizing
- **Undo/Redo**: Edit history and reversible actions

## 🎨 Design Philosophy
- **Instagram-Inspired**: Familiar UX patterns from popular social apps
- **Professional Quality**: Precise controls for serious photo editing
- **Local-First**: Privacy-focused with all editing done on-device
- **Intuitive Gestures**: Natural touch interactions without learning curve

## 📁 Project Structure
```
SwiftVisualPoetry/
├── SwiftVisualPoetryApp.swift          # App entry point
├── Views/
│   ├── ContentView.swift               # Tab navigation
│   ├── CameraView.swift                # Camera capture tab
│   ├── GalleryView.swift               # Photo selection tab
│   ├── PersonalGalleryView.swift       # Saved photos tab
│   ├── PhotoEditorView.swift           # Main editing interface
│   ├── InlineTextEditingView.swift     # Text styling controls
│   └── DraggableTextView.swift         # Text positioning component
├── Models/
│   └── TextOverlay.swift               # Text properties data model
├── Coordinators/
│   ├── CameraCoordinator.swift         # Camera integration
│   └── PhotoPickerCoordinator.swift    # Gallery integration
└── Documentation/
    ├── PROJECT_ROADMAP.md              # Feature tracking
    ├── XCODE_SETUP.md                  # Development setup
    └── INFO_PLIST_REQUIREMENTS.md      # Configuration guide
```

## 🚀 Getting Started
1. Clone the repository
2. Open `SwiftVisualPoetry.xcodeproj` in Xcode
3. Add required Info.plist entries for camera/photo permissions
4. Build and run on simulator or device
5. Test with Camera tab (device) or Gallery tab (simulator)

## 🤝 Contributing
This project showcases modern iOS development with SwiftUI. Key learning areas:
- Advanced gesture recognition and simultaneous handling
- PhotosUI framework integration for modern photo selection  
- Camera permissions and UIKit bridging in SwiftUI
- Complex state management for editing interfaces
- Professional UI/UX design patterns from popular apps

---
**Built with ❤️ using SwiftUI and modern iOS development practices**