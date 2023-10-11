//
//  PopUpMenu.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/4/23.
//

import SwiftUI



struct PopUpMenu: View {
    
    @EnvironmentObject var router: AddScreenViewRouterManager
    
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
               
                ForEach(AddScreenViewModel.allCases, id: \.self) { view in
                    MenuItem(currentScreen: view)
                        .frame(maxWidth: .infinity)
                }
                
            }
            .frame(height: 100)
            .background(BlurView(style: .systemThinMaterial))
            .cornerRadius(20)
            .padding(20)
            
        }
        .transition(.slide)
    }
}

struct MenuItem: View {
   
    var currentScreen: AddScreenViewModel
    @EnvironmentObject var router: AddScreenViewRouterManager
    @EnvironmentObject var coreModel: CoreModel
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Button {
                router.currentScreen = currentScreen
                router.isSheetPresented = true
                coreModel.showAddPopMenu.toggle()
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .shadow(radius: 4)
                        .foregroundColor(currentScreen.fillColor)
                    Image(systemName: currentScreen.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 40)
                        .foregroundColor(Color(.white))
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
        PopUpMenu()
            .environmentObject(AddScreenViewRouterManager())
    }
}
