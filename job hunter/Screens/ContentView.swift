//
//  ContentView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/24/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var router = AddScreenViewRouterManager()
    var body: some View {
        CustomTabView(router: router)
            .environmentObject(router)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(router: AddScreenViewRouterManager())
            .environmentObject(AddScreenViewRouterManager())
    }
}
