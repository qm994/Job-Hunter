//
//  ProfileScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/22/23.
//

import SwiftUI

struct TopTabBarView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            Picker("Tabs", selection: $selectedTab) {
                Text("Tab 1").tag(0)
                Text("Tab 2").tag(1)
                Text("Tab 3").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TabView(selection: $selectedTab) {
                Text("Content of Tab 1")
                    .tag(0)
                Text("Content of Tab 2")
                    .tag(1)
                Text("Content of Tab 3")
                    .tag(2)
            }
        }
    }
}

struct ProfileScreenView: View {

    let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @EnvironmentObject var authModel: AuthenticationModel

    var body: some View {
        VStack {
            // Simulated line
            Rectangle()
                .frame(height: 1) // Set the height to 1 to create a line
                .foregroundColor(.gray) // Set the line color
            
            
            ProfileTopView()
            
            TopTabBarView()
           
            //TODO: IMGAE
            
            List {
                Section(header: Text("Section 1 Header")) {
                    Text("Item 1")
                    Text("Item 2")
                    Text("Item 3")
                }
                
                Section(header: Text("Section 2 Header"), footer: Text("Section 2 Footer")) {
                    Text("Item 4")
                    Text("Item 5")
                    Text("Item 6")
                }
                
                Section(header: Text("Authentication")) {
                    SignOutView()
                }
                
                if let user = authModel.userProfile {
                    Text("user id: \(user.userId)")
                    if let dateCreated = user.dateCreated {
                        Text(DateFormatter().string(from: dateCreated))
                    }
                    if let email = user.email {
                        Text(email)
                    }
                }
            }
            .listSectionSeparator(.hidden)
            
           
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {

                } label: {
                    Image(systemName: "gear")
                        .font(.title2)
                }
            }
        }
        .onAppear {
            Task {
                try await authModel.loadCurrentUser()
            }
        }
        
    }
}

struct ProfileScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TabView {
                ProfileScreenView()
                    .navigationTitle("Account")
                    .environmentObject(AuthenticationModel())
            }
            .tabViewStyle(
                PageTabViewStyle(indexDisplayMode: .never))
            
        }
        .navigationDestination(for: String.self) { value in
            if value == NavigationPath.addInterviewScreen.rawValue {
                Text("Add Screen")
            }
        }
    }
}
