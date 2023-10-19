//
//  ContentView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/24/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var router = AddScreenViewRouterManager()
    @StateObject var coreModel = CoreModel()

    //@State private var showAuthView: Bool = false
    
    @StateObject var authModel = AuthenticationModel()
    
    var body: some View {
        CustomTabView()
            .environmentObject(authModel)
            .environmentObject(router)
            .environmentObject(coreModel)
            .onAppear {
                let authUser = try? AuthenticationManager.sharedAuth.getAuthenticatedUser()
                
                authModel.showAuthMainScreen = authUser == nil ? true : false
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
