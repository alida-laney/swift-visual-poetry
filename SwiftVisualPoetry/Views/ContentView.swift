import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CameraView()
                .tabItem {
                    Image(systemName: "camera")
                    Text("Camera")
                }
                .tag(0)
            
            GalleryView()
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Gallery")
                }
                .tag(1)
            
            PersonalGalleryView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("My Photos")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}