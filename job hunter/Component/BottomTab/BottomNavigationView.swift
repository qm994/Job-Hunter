//
//  BottomNavigationView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/19/23.
//

import SwiftUI

enum BottomNavigationModel: Int, CaseIterable {
    case home
    case profile
    
    var tabIcon: String {
        switch self {
            case .home: 
                return "house.fill"
            case .profile:
                return "person.crop.circle"
        }
    }
    
    var tabName: String {
        switch self {
            case .home:
                return "Home"
            case .profile:
                return "Profile"
        }
    }
}


struct TabButton: View {
    var tab: BottomNavigationModel
    @EnvironmentObject var coreModel: CoreModel
    
    var body: some View {
        Button {
            coreModel.selectedTab = tab
        } label: {
            VStack(spacing: 10) {
                Image(systemName: tab.tabIcon)
                    .font(Font.title2.weight(.bold))
                
                Text(tab.tabName)
            }
            .foregroundColor(
                coreModel.selectedTab == tab
                ? .blue
                : .white
            )
        }
    }
}


struct BottomNavigationView: View {
    @EnvironmentObject var coreModel: CoreModel
    
    //@Binding var path: [String]
    
    var body: some View {
        HStack(spacing: 50) {
            TabButton(tab: .home)
            TabButton(tab: .profile)
        }
        .frame(height: UIScreen.main.bounds.height / 10)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .padding(.horizontal, 40)
        .background(Color(.systemGray5))
//        .clipShape(
//            RoundedRectangle(cornerRadius: 20)
//        )
        .overlay(
            Rectangle()
                .fill(Color.gray)
                .frame(height: 2),
            alignment: .top
        )
    }
}

#Preview {
    BottomNavigationView()
        .environmentObject(CoreModel())
}
