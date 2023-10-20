//
//  CustomTabView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/3/23.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var router: AddScreenViewRouterManager
    @EnvironmentObject var coreModel: CoreModel
    
    var body: some View {
        
        ZStack{
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
             
                //MARK: TABVIEW
                TabView(selection: $coreModel.selectedTab) {
                    HomeScreenView()
                        .tag(BottomNavigationModel.home)

                    ProfileScreenView()
                        .tag(BottomNavigationModel.profile)

                } //TabView ends
                .tabViewStyle(
                    PageTabViewStyle(indexDisplayMode: .always))
                .ignoresSafeArea(.all, edges: .bottom)
                
                //MARK: Bottom Navigation
                BottomNavigationView()
                    
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
            .environmentObject(AuthenticationModel())
            .environmentObject(AddScreenViewRouterManager())
            .environmentObject(CoreModel())
    }
}
