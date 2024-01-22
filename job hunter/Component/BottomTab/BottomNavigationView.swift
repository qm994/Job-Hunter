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
    case companies
    case logInterview
    
    var tabIcon: String {
        switch self {
            case .home: 
                return "house.circle.fill"
            case .profile:
                return "person.crop.circle"
            case .companies:
                return "building.2.crop.circle.fill"
            case .logInterview:
                return "plus.square.fill.on.square.fill"
        }
    }
    
    var tabName: String {
        switch self {
            case .home:
                return "Home"
            case .profile:
                return "Profile"
            case .companies:
                return "Companies"
            case .logInterview:
                return "Log Interview"
        }
    }
}


struct TabButton: View {
    var tab: BottomNavigationModel
    @EnvironmentObject var coreModel: CoreModel
    
    var action: (() -> Void)?
    var body: some View {
        Button {
            if tab == .logInterview {
                // Perform navigation when the logInterview tab is tapped
                withAnimation {
                    coreModel.path.append(NavigationPath.addInterviewScreen.rawValue)
                }
            } else {
                // For other tabs, just update the selectedTab
                coreModel.selectedTab = tab
            }
        } label: {
            VStack(spacing: 10) {
                Image(systemName: tab.tabIcon)
                    .font(Font.title2.weight(.bold))
                
                Text(tab.tabName)
                    .font(.footnote)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
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
    
    @State private var showWarning = false
    
    var body: some View {
        VStack {
            Spacer()
            Divider() // This replaces the overlay with a simple line.

            HStack(spacing: 5) {
                TabButton(tab: .home)
                TabButton(tab: .companies)
                TabButton(tab: .logInterview)
                    .disabled(coreModel.addButtonStatus == "disabled")
                   
                    .onTapGesture {
                        if coreModel.addButtonStatus == "disabled" {
                            showWarning.toggle() // Toggle tooltip visibility
                        } else {
                            //onTap.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    coreModel.path.append(NavigationPath.addInterviewScreen.rawValue)
                                }
                            }
                        }
                    }
                    
                TabButton(tab: .profile)
            }
            .padding(.horizontal, 5)
            .padding(.vertical) // Add some vertical padding for space around the buttons.
            //.frame(height: 82) // Fixed height for the tab bar
            .background(Color(.systemGray5))
        }
        .onChange(of: interviewModel.interviews) { _ in
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
        .alert(isPresented: $showWarning) {
            Alert(
                title: Text(LocalizedStringKey("Not Support!")),
                message:  Text(LocalizedStringKey("For cost reasons, we can only support user add at most 10 interviews. Once we figure out the cost, more spaces will be available. Stay tuned!")),
                dismissButton: .default(Text(LocalizedStringKey("OK")))
            )
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
