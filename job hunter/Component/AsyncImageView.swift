//
//  AsyncImageView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/15/23.
//

import SwiftUI

struct AsyncImageView<Placeholder: View>: View {
    
    let url: String
    var placeholder: () -> Placeholder
    
    init(url: String, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            // Success: Display the loaded image.
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
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
    AsyncImageView(url: "https://logo.clearbit.com/segmentify.com") {
        //Image(systemName: "photo")
        ProgressView()
            .frame(width: 100, height: 100)
    }
}
