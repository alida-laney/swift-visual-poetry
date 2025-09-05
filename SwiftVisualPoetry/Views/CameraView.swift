import SwiftUI

struct CameraView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("📸")
                    .font(.system(size: 100))
                
                Text("Camera View")
                    .font(.title)
                    .padding()
                
                Text("Tap to capture photos")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button("Open Camera") {
                    // TODO: Implement camera functionality
                }
                .buttonStyle(.borderedProminent)
                .font(.headline)
            }
            .navigationTitle("Camera")
        }
    }
}

#Preview {
    CameraView()
}