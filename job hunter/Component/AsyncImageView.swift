//
//  AsyncImageView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/15/23.
//

import SwiftUI

struct AsyncImageView<Placeholder: View>: View {
    
    let url: String
    let geometry: GeometryProxy?
    var placeholder: () -> Placeholder
    
    init(url: String, geometry: GeometryProxy? = nil, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.geometry = geometry
        self.placeholder = placeholder
    }
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
                case .success(let image):
                    image
                        .resizable() // Apply resizable to the image itself
                        .scaledToFit()
                case .failure(_):
                    placeholder()
                case .empty:
                    placeholder()
                @unknown default:
                    placeholder()
            }
        }
        .aspectRatio(1, contentMode: .fit) // Control the aspect ratio
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
        .frame(width: geometry?.size.width, height: geometry?.size.height)
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
