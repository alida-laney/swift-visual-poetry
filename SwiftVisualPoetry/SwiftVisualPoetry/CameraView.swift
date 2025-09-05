//
//  CameraView.swift
//  SwiftVisualPoetry
//
//  Created by Alida on 9/5/25.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage?
    @State private var showPhotoEditor = false
    @State private var showPermissionAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("📸")
                    .font(.system(size: 100))
                
                Text("Camera View")
                    .font(.title)
                    .padding()
                
                Text(UIImagePickerController.isSourceTypeAvailable(.camera) ? 
                     "Tap to capture photos" : "Select photos from library")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(UIImagePickerController.isSourceTypeAvailable(.camera) ? 
                       "Open Camera" : "Choose Photo") {
                    checkCameraPermission()
                }
                .buttonStyle(.borderedProminent)
                .font(.headline)
                .padding(.bottom, 50)
            }
            .navigationTitle("Camera")
            .sheet(isPresented: $isShowingCamera) {
                CameraCoordinator(selectedImage: $capturedImage, isPresenting: $isShowingCamera)
            }
            .fullScreenCover(isPresented: $showPhotoEditor) {
                if let image = capturedImage {
                    PhotoEditorView(image: image)
                }
            }
            .alert("Camera Permission Required", isPresented: $showPermissionAlert) {
                Button("Settings") {
                    openSettings()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please allow camera access in Settings to take photos.")
            }
            .onChange(of: capturedImage) { _, newImage in
                if newImage != nil {
                    showPhotoEditor = true
                }
            }
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isShowingCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        isShowingCamera = true
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
    CameraView()
}