//
//  TabButtonView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/3/23.
//

import SwiftUI

struct TabButtonView: View {
    var imageName: String
    @Binding var selectedTab: String
    
    
    
    var body: some View {
        Button {
            selectedTab = imageName
        } label: {
            Image(systemName: imageName)
                .foregroundColor(selectedTab == imageName ? .green : .white)
                .font(Font.title2.bold())
        }
        .onAppear {
            print(selectedTab)
            print(imageName)
        }
    }
}

struct TabButtonView_Previews: PreviewProvider {
    @State static var selectedTab = "house.fill"  // Provide a default value
        
        static var previews: some View {
            TabButtonView(imageName: "house.fill", selectedTab: $selectedTab)  // Pass the required parameters
        }
}
