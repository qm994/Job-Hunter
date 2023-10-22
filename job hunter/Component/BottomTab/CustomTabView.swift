//
//  CustomTabView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/3/23.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = "house.fill"
    
    
    @EnvironmentObject var router: AddScreenViewRouterManager
    @EnvironmentObject var coreModel: CoreModel
    
    var body: some View {
        
        ZStack{
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
             
                //MARK: TABVIEW
                TabView(selection: $selectedTab) {
                    HomeScreenView()
<<<<<<< Updated upstream
                        .tag("house.fill")

                    ProfileScreenView()
                        .tag("person.crop.circle")

=======
                        .tag(BottomNavigationModel.home)
                    
                    NavigationStack {
                        ProfileScreenView()
                    }
                    .tag(BottomNavigationModel.profile)
                
>>>>>>> Stashed changes
                } //TabView ends
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .ignoresSafeArea(.all, edges: .bottom)
                
                //MARK: TabView bottom tab buttons
                HStack {
                    TabButtonView(imageName: "house.fill", selectedTab: $selectedTab)
                    Spacer()
                    TabMenuIcon()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                                coreModel.showAddPopMenu.toggle()
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
            
            if (coreModel.showAddPopMenu) {
                PopUpMenu()
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
        CustomTabView()
            .environmentObject(AddScreenViewRouterManager())
            .environmentObject(CoreModel())
    }
}
