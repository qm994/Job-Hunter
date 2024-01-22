//
//  ProfileScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/22/23.
//

import SwiftUI

struct ProfileScreenView: View {
    
    @EnvironmentObject var authModel: AuthenticationModel
    @EnvironmentObject var coreModel: CoreModel
    

    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
  
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 5) {
                HStack {
                    Spacer()
                    Button {
                        coreModel.path.append(NavigationPath.settingsView.rawValue)
                    } label: {
                        Image(systemName: "gear")
                            .font(.title2)
                    }
                }
                .padding(.trailing, 15)
                
                // Simulated line
                Rectangle()
                    .frame(height: 1) // Set the height to 1 to create a line
                    .foregroundColor(.gray) // Set the line color
                
                
                ProfileTopView()
                    .frame(height: geometry.size.height * 0.3)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
                ProfileTabsView()
                    
            } // Vstack ends
            //.frame(height: geometry.size.height)
        }
    }
}

struct ProfileScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
                ProfileScreenView()
                    //.navigationTitle("Profile")
                    .environmentObject(AuthenticationModel())
                    .environmentObject(CoreModel())
                    .environmentObject(InterviewsViewModel())
            
            
                //BottomNavigationView()
        
        }
        .navigationDestination(for: String.self) { value in
            if value == NavigationPath.addInterviewScreen.rawValue {
                Text("Add Screen")
            }
        }
    }
}
