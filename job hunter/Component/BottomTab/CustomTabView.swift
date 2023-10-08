//
//  CustomTabView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/3/23.
//

import SwiftUI

let images = ["house.fill", "plus.circle.fill", "person.crop.circle"]


struct CustomTabView: View {
    @State private var selectedTab = "house.fill"
    @State private var showMenu: Bool = false
    @ObservedObject var router: AddScreenViewRouterManager
    
    var body: some View {
        
        ZStack{
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
             
                //MARK: TABVIEW
                TabView(selection: $selectedTab) {
                    HomeScreenView()
                        .tag("house.fill")

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
            
            if (showMenu) {
                PopUpMenu(router: router, showMenu: $showMenu)
                    .padding(.vertical, UIScreen.main.bounds.height / 8 + 40)
            }
        }
        //MARK: SHOW THE ADDING SHEET
        .sheet(isPresented: $router.isSheetPresented) {
            if router.currentScreen != nil {
                router.view
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.large])
                
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct CustomTabView_Previews: PreviewProvider {
   
    static var previews: some View {
        CustomTabView(router: AddScreenViewRouterManager())
            .environmentObject(AddScreenViewRouterManager())
    }
}
