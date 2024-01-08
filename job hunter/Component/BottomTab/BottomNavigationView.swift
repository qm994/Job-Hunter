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
    @EnvironmentObject var authModel: AuthenticationModel
    @ObservedObject var interviewModel: InterviewsViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Divider() // This replaces the overlay with a simple line.

            HStack(spacing: 50) {
                TabButton(tab: .home)
                CirclePlusAddButton() {
                    withAnimation {
                        coreModel.path.append(NavigationPath.addInterviewScreen.rawValue)
                    }
                }
                TabButton(tab: .profile)
            }
            .padding(.horizontal, 40)
            .padding(.vertical) // Add some vertical padding for space around the buttons.
            .frame(height: 82) // Fixed height for the tab bar
            .background(Color(.systemGray5))
        }
        .onChange(of: interviewModel.interviews) {
            if let userProfile = authModel.userProfile {
                let currentCounts = interviewModel.interviews.count
                let maxAllowed = userProfile.maxInterviewsAllowed
                if currentCounts < maxAllowed {
                    coreModel.addButtonStatus = "enabled"
                } else {
                    coreModel.addButtonStatus = "disabled"
                }
            }
        }
    }
}


#Preview {
    struct Wrapper: View {
        @StateObject var interviewModel = InterviewsViewModel()
        var body: some View {
            BottomNavigationView(interviewModel: interviewModel)
                .environmentObject(CoreModel())
                .environmentObject(AuthenticationModel())
        }
    }
    return Wrapper()
}
