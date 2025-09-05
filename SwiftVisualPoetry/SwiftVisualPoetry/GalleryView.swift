//
//  GalleryView.swift
//  SwiftVisualPoetry
//
//  Created by Alida on 9/5/25.
//

import SwiftUI
import PhotosUI

struct GalleryView: View {
    @State private var isShowingPhotoPicker = false
    @State private var selectedImage: UIImage?
    @State private var showPhotoEditor = false
    @State private var showPermissionAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("🖼️")
                    .font(.system(size: 100))
                
                Text("Photo Gallery")
                    .font(.title)
                    .padding()
                
                Text("Choose from your photos")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button("Browse Photos") {
                    checkPhotoLibraryPermission()
                }
                .buttonStyle(.borderedProminent)
                .font(.headline)
                .padding(.bottom, 50)
            }
            .navigationTitle("Gallery")
            .sheet(isPresented: $isShowingPhotoPicker) {
                PhotoPickerCoordinator(selectedImage: $selectedImage, isPresenting: $isShowingPhotoPicker)
            }
            .fullScreenCover(isPresented: $showPhotoEditor) {
                if let image = selectedImage {
                    PhotoEditorView(image: image)
                }
            }
            .alert("Photo Access Required", isPresented: $showPermissionAlert) {
                Button("Settings") {
                    openSettings()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please allow photo access in Settings to browse your photo library.")
            }
            .onChange(of: selectedImage) { _, newImage in
                if newImage != nil {
                    showPhotoEditor = true
                }
            }
        }
    }
    
    private func checkPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            isShowingPhotoPicker = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        isShowingPhotoPicker = true
                    } else {
                        showPermissionAlert = true
                    }
                }
            }
        default:
            showPermissionAlert = true
        }
    }
    
    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

#Preview {
    GalleryView()
}