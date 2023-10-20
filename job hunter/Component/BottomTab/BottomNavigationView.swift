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
            coreModel.showAddPopMenu = false
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
    
    var body: some View {
        HStack {
            TabButton(tab: .home)
            TabMenuIcon()
                .onTapGesture {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                        coreModel.showAddPopMenu.toggle()
                    }
                }
            TabButton(tab: .profile)
        }
        .frame(height: UIScreen.main.bounds.height / 8)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
        .background(Color(.systemGray5))
    }
}

#Preview {
    BottomNavigationView()
        .environmentObject(CoreModel())
}
