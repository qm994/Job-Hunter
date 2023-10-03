//
//  BottomNavigationView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/24/23.
//

import SwiftUI

struct BottomNavigationView: View {
    @State private var showMenu = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // First Tab
            Text("Home page")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            Text("Add new item")
                .tabItem {
                    ZStack {
                        Circle()
                            .frame(width: 56, height: 56)
                            .foregroundColor(.white)
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(.systemBlue))
                            
                    }
                }
                .tag(1)
            
            
            Text("Profile page")
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(2)
        }
//        VStack {
//            Spacer()
//            HStack {
//                Spacer()
//                Button(action: {
//                    showMenu.toggle()
//                }) {
//                    Image(systemName: "plus.circle")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                        .foregroundColor(selectedTab == 1 ? .blue : .gray)
//                }
//                .padding(.bottom, 10)
//                .padding(.trailing, 50)
//                .contextMenu {
//                    if showMenu {
//                        Button("Option 1", action: { /* Do something */ })
//                        Button("Option 2", action: { /* Do something */ })
//                        Button("Option 3", action: { /* Do something */ })
//                    }
//                }
//                Spacer()
//            }
//        }
    }
}

struct BottomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationView()
    }
}
