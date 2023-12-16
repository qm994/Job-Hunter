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
                    .onAppear {
                        Task {
                            try await authModel.loadCurrentUser()
                        }
                    }
                    .transition(.slide)
                    .animation(.linear, value: authModel.isLoggedIn)
    //                    .fullScreenCover(isPresented: $authModel.showAuthMainScreen) {
    //                        AuthenticationMainScreen()
    //                            .environmentObject(authModel)
    //                    }
            } else {
                AuthenticationMainScreen()
                    .environmentObject(authModel)
                    //.transition(.move(edge: .leading))
            }
        }
    }
}

#Preview {
    IndexScreen()
}
