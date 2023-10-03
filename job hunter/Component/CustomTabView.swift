//
//  CustomTabView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/3/23.
//

import SwiftUI

let images = ["house.fill", "plus.circle.fill", "person.crop.circle"]

struct TabMenuIcon: View {
    @Binding var showMenu: Bool
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .shadow(radius: 4)
            
            Image(systemName: showMenu ? "xmark.circle.fill" : "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(Color(.systemBlue))
                .rotationEffect(Angle(degrees: showMenu ? 90 : 0))
            
        }
        .offset(y: -44)
    }
}


struct CustomTabView: View {
    @State private var selectedTab = "house.fill"
    @State private var showMenu: Bool = false
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $selectedTab) {
                HomeScreenView()
                    .tag("house.fill")
                
//                AddInterviewView()
//                    .tag("plus.circle.fill")
                
                ProfileScreenView()
                    .tag("person.crop.circle")
                
            } //TabView ends
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .ignoresSafeArea(.all, edges: .bottom)
            
            //MARK: TabView bottom tab buttons
            HStack {
                TabButtonView(imageName: "house.fill", selectedTab: $selectedTab)
                Spacer()
                TabMenuIcon(showMenu: $showMenu)
                    .onTapGesture {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }
                Spacer()
                TabButtonView(imageName: "person.crop.circle", selectedTab: $selectedTab)
            }// Bottom buttons Ends
            .frame(height: UIScreen.main.bounds.height / 8)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 40)
            .background(Color(.systemGray5))
        }// Zstack ends
        .ignoresSafeArea(.all, edges: .bottom)
        .preferredColorScheme(.dark)
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
