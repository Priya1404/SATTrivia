import SwiftUI

struct GifView: View {
    let gifName: String
    
    var body: some View {
        // We'll need to implement this view to display GIFs
        // For now, we'll use a placeholder
        Image(systemName: gifName == "winner" ? "star.fill" : "cloud.rain.fill")
            .font(.system(size: 60))
            .foregroundColor(gifName == "winner" ? .yellow : .gray)
    }
} 