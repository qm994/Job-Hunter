//
//  ContentView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/24/23.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @StateObject var authModel = AuthenticationModel()

    var body: some View {
        DebugView("\(authModel.userProfile)")
        MainScreenView()
            .environmentObject(authModel)
            .environmentObject(AddScreenViewRouterManager())
            .environmentObject(CoreModel())
            /// check if user authenticated, otherwise show the auth screen
            .onAppear {
                Task {
                    do {
                        let authUser = try await authModel.loadCurrentUser()
                        authModel.showAuthMainScreen = authUser == nil ? true : false
                    } catch let error {
                        authModel.showAuthMainScreen = true
                        print("load app auth issue: \(error.localizedDescription)")
                    }
                }
            }
            .fullScreenCover(isPresented: $authModel.showAuthMainScreen) {
                AuthenticationMainScreen()
                    .environmentObject(authModel)
            }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AddScreenViewRouterManager())
    }
}
