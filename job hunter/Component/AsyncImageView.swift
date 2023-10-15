//
//  AsyncImageView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/15/23.
//

import SwiftUI

struct AsyncImageView: View {
    
    let url: String
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            // Image successfully loaded
            image
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)  // Adjust size to match typical system image icon size
                .clipShape(Circle())  // Clip image to a circle shape
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))  // Optional: Add border
        } placeholder: {
            // Placeholder while loading
            ProgressView()
                .frame(width: 100, height: 100)
        }
    }
}


#Preview {
    AsyncImageView(url: "https://logo.clearbit.com/segmentify.com")
}
