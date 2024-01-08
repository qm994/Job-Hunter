//
//  ProfileTabsView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 12/22/23.
//

import SwiftUI

struct ProfileTabsView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            Picker("Tabs", selection: $selectedTab) {
                Text("Statistics").tag(0)
                Text("Chart").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TabView(selection: $selectedTab) {
                VStack {
                    Text("Incoming...")
                }
                .tag(0)
                .font(.largeTitle)
                
                VStack {
                    Text("Incoming...")
                }
                .tag(1)
                .font(.largeTitle)
            }
        }
        //.overlay(Rectangle().stroke())
    }
}


#Preview {
    ProfileTabsView()
}
