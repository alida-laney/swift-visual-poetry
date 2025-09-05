import SwiftUI

struct PersonalGalleryView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("❤️")
                    .font(.system(size: 100))
                
                Text("My Creations")
                    .font(.title)
                    .padding()
                
                Text("Your edited photos")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("No photos yet")
                    .foregroundColor(.gray)
                    .italic()
            }
            .navigationTitle("My Photos")
        }
    }
}

#Preview {
    PersonalGalleryView()
}