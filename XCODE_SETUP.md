# Xcode Project Setup Instructions

## Creating the iOS App in Xcode

Since we can't generate Xcode project files directly, follow these steps to create the iOS app:

### Step 1: Create New Xcode Project
1. Open Xcode
2. Choose "Create a new Xcode project"
3. Select **iOS > App**
4. Fill in project details:
   - Product Name: `SwiftVisualPoetry`
   - Bundle Identifier: `com.yourname.swiftvisualpoetry`
   - Language: **Swift**
   - Interface: **SwiftUI**
   - Use Core Data: **No** (we'll use local storage)

### Step 2: Replace Generated Files
1. Delete the generated `ContentView.swift` and `SwiftVisualPoetryApp.swift` from your Xcode project
2. From the repository root, copy these files into your Xcode project:
   - `SwiftVisualPoetry/SwiftVisualPoetryApp.swift` → Replace the main app file
   - `SwiftVisualPoetry/Views/ContentView.swift` → Replace ContentView
   - `SwiftVisualPoetry/Views/CameraView.swift` → Add new file
   - `SwiftVisualPoetry/Views/GalleryView.swift` → Add new file  
   - `SwiftVisualPoetry/Views/PersonalGalleryView.swift` → Add new file
3. In Xcode, create a new group called "Views" and organize the view files there

### Step 3: Final Project Structure in Xcode
Your Xcode project should look like this:
```
SwiftVisualPoetry (Xcode project)
├── SwiftVisualPoetryApp.swift      (Main app entry point)
├── Views/                          (Group in Xcode)
│   ├── ContentView.swift           (Tab navigation)
│   ├── CameraView.swift           (Camera tab)
│   ├── GalleryView.swift          (Gallery picker tab)
│   └── PersonalGalleryView.swift  (Personal gallery tab)
└── [Other Xcode generated files]
```

### Step 4: Test the App
1. Select a simulator or device
2. Build and run (⌘+R)
3. You should see a tab-based app with Camera, Gallery, and My Photos tabs

## Next Steps
Once the basic app is running, we'll implement:
- Camera capture functionality
- Photo gallery picker
- Photo editing canvas
- Text overlay system with gestures