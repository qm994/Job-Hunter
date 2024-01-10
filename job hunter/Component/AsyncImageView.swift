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
                .frame(width: geometry.size.width, height: geometry.size.height) // Apply frame to the entire AsyncImage
            }
//        AsyncImage(url: URL(string: url)) { phase in
//            // Success: Display the loaded image.
//            
//            if let image = phase.image {
//                image
//                    .resizable()
//                    .scaledToFit()
//                    .scaleEffect(0.7)
//                    //.aspectRatio(0.70, contentMode: .fill)
//                    .clipShape(Circle())
//                    .foregroundColor(Color.white)
//                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
//                
//            } else if phase.error != nil {
//                // Error: Display a fallback image or a custom error view.
//                placeholder()
//            } else {
//                // Loading: Show a progress indicator.
//                placeholder()
//            }
//        }
    //}
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
