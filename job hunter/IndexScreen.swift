//
//  IndexScreen.swift
//  job hunter
//
//  Created by Qingyuan Ma on 11/22/23.
//

import SwiftUI

struct IndexScreen: View {
    @StateObject var authModel: AuthenticationModel = AuthenticationModel()
    var body: some View {
        DebugView("\(authModel.userProfile)")
        Group {
            if authModel.isLoggedIn, let _  = authModel.userProfile {
                MainScreenView()
                    .environmentObject(authModel)
                    .environmentObject(CoreModel())
                    .transition(.slide)
                    .animation(.linear, value: authModel.isLoggedIn)
                    
            } else {
                AuthenticationMainScreen()
                    .environmentObject(authModel)
            }
        }
        
        .onAppear {
            Task {
                try await authModel.loadCurrentUser()
            }
        }
    }
}

#Preview {
    IndexScreen()
}
