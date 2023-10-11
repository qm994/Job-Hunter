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
    var body: some View {
        CustomTabView()
            .environmentObject(router)
            .environmentObject(coreModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AddScreenViewRouterManager())
    }
}
