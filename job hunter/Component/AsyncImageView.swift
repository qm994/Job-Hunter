//
//  AsyncImageView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/15/23.
//

import SwiftUI

struct AsyncImageView<Placeholder: View>: View {
    
    let url: String
    let geometry: GeometryProxy
    var placeholder: () -> Placeholder
    
    init(url: String, geometry: GeometryProxy, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.geometry = geometry
        self.placeholder = placeholder
    }
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            // Success: Display the loaded image.
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(0.70, contentMode: .fill)
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                    .clipShape(Circle())
                    .foregroundColor(Color.white)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            } else if phase.error != nil {
                // Error: Display a fallback image or a custom error view.
                placeholder()
            } else {
                // Loading: Show a progress indicator.
                placeholder()
            }
        }
    }
}


#Preview {
    GeometryReader {
        geometry in
        AsyncImageView(url: "https://logo.clearbit.com/segmentify.com", geometry: geometry) {
            //Image(systemName: "photo")
            ProgressView()
                .frame(width: 100, height: 100)
        }

    }
}
