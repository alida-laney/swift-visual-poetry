# Required Info.plist Entries

For the camera and photo library functionality to work, you need to add the following to your app's `Info.plist` file:

## Camera Permission
Add this key-value pair to request camera access:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to the camera to take photos for editing.</string>
```

## Photo Library Permission
Add this key-value pair to request photo library access:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to your photo library to select photos for editing.</string>
```

## How to Add in Xcode:
1. In your Xcode project, find `Info.plist`
2. Right-click and select "Open As" > "Source Code"
3. Add the XML above inside the `<dict>` tags
4. Or use the GUI: Add new row, select "Privacy - Camera Usage Description", set value to the description

## For Testing:
- Camera functionality **requires a physical device** (won't work in simulator)
- Make sure to test on an actual iPhone/iPad