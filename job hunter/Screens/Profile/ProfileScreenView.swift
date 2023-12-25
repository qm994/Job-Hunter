//
//  ProfileScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/22/23.
//

import SwiftUI

struct ProfileScreenView: View {

    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @EnvironmentObject var authModel: AuthenticationModel

    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                // Simulated line
                Rectangle()
                    .frame(height: 1) // Set the height to 1 to create a line
                    .foregroundColor(.gray) // Set the line color
                
                
                ProfileTopView()
                .frame(height: geometry.size.height * 0.15)
                
                ProfileTabsView()
                
                List {
                    Section(header: Text("Authentication")) {
                        SignOutView()
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
                }
                .listSectionSeparator(.hidden)
                
                
            } // Vstack ends
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "gear")
                            .font(.title2)
                    }
                }
            }//toolbar ends
        }
    }
}

struct ProfileScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileScreenView()
                .navigationTitle("Account")
                .environmentObject(AuthenticationModel())
            
        }
        .navigationDestination(for: String.self) { value in
            if value == NavigationPath.addInterviewScreen.rawValue {
                Text("Add Screen")
            }
        }
    }
}
