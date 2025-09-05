import SwiftUI

struct GalleryView: View {
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
                    // TODO: Implement photo picker
                }
                .buttonStyle(.borderedProminent)
                .font(.headline)
            }
            .navigationTitle("Gallery")
        }
    }
}

#Preview {
    GalleryView()
}