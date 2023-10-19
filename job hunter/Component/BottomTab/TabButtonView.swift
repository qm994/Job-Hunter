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
    
    @EnvironmentObject var coreModel: CoreModel
    
    var body: some View {
        Button {
            coreModel.showAddPopMenu = false
            selectedTab = imageName
        } label: {
            Image(systemName: imageName)
                .foregroundColor(selectedTab == imageName ? .green : .gray)
                .font(Font.title2.weight(.bold))
        }
        .onAppear {
            
        }
    }
}




struct TabButtonView_Previews: PreviewProvider {
    @State static var selectedTab = "house.fill"  // Provide a default value
    
    static var previews: some View {
        TabButtonView(imageName: "house.fill", selectedTab: $selectedTab)
            .environmentObject(CoreModel())
    }
}
