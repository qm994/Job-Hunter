//
//  ContentView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/24/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var router = AddScreenViewRouterManager()
    @ObservedObject var coreModel = CoreModel()

    @State private var showAuthView: Bool = false
    
    
    var body: some View {
        CustomTabView()
            .environmentObject(router)
            .environmentObject(coreModel)
            .onAppear {
                let authUser = try? AuthenticationManager.sharedAuth.getAuthenticatedUser()
                print("authenticated user from ContentView: \(authUser?.email ?? "No authenticated user")")
                showAuthView = authUser == nil ? true : false
            }
            .fullScreenCover(isPresented: $showAuthView) {
                AuthenticationMainScreen()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AddScreenViewRouterManager())
    }
}
