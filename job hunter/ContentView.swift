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
        DebugView("\(authModel.isLoggedIn)")
        Group {
            if authModel.isLoggedIn {
                MainScreenView()
                    .environmentObject(authModel)
                    .environmentObject(CoreModel())
                    //.transition(.move(edge: .trailing))
//                    .fullScreenCover(isPresented: $authModel.showAuthMainScreen) {
//                        AuthenticationMainScreen()
//                            .environmentObject(authModel)
//                    }
            } else {
                AuthenticationMainScreen()
                    .environmentObject(authModel)
                    //.transition(.move(edge: .leading))
            }
        } //Group ends
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
