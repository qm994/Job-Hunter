//
//  PopUpMenu.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/4/23.
//

import SwiftUI



struct PopUpMenu: View {
    
    @ObservedObject var router: AddScreenViewRouterManager
    @Binding var showMenu: Bool
    
    let AddMenuItemNames = [
        "Add Pending": "questionmark.circle.fill",
        "Add Succeed": "checkmark.circle.fill",
        "Add Rejected": "xmark.circle.fill"
    ]
    
    var sortedKeys: [String] {
        return Array(AddMenuItemNames.keys).sorted(by: <)
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom, spacing: 10) {
                Spacer()
                ForEach(AddScreenViewModel.allCases, id: \.self) { view in
                    MenuItem(currentScreen: view, router: router, showMenu: $showMenu)
                        .frame(maxWidth: .infinity)
                }
                Spacer()
            }
        }
        .transition(.slide)
    }
}


struct MenuItem: View {
   
    var currentScreen: AddScreenViewModel
    @ObservedObject var router: AddScreenViewRouterManager
    @Binding var showMenu: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Button {
                router.currentScreen = currentScreen
                router.isSheetPresented = true
                showMenu.toggle()
            } label: {
                ZStack() {
                    Circle()
                        .foregroundColor(Color(.white))
                        .frame(width: 40, height: 40)
                        .shadow(radius: 4)
                    Image(systemName: currentScreen.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(.systemCyan))
                }
            }
            
            Text(currentScreen.textLabel)
                .font(.body)
                .multilineTextAlignment(.center)
    
        }
    }
}



struct PopUpMenu_Previews: PreviewProvider {
    
    static var previews: some View {
        PopUpMenu(router: AddScreenViewRouterManager(), showMenu: .constant(false))
    }
}
