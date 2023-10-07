//
//  BottomTabViewRouter.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/4/23.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentScreen: AddScreenViewModel?
    @Published var isSheetPresented: Bool = false
    var view: some View { return currentScreen?.addScreenView }
}


enum AddScreenViewModel: Int, CaseIterable {
    case addUpComing
    case addPending
    case addSucceed
    case addRejected
    
    var imageName: String {
        switch self {
        case .addUpComing:
            return "infinity.circle.fill"
        case .addPending:
           return "questionmark.circle.fill"
        case .addSucceed:
            return "checkmark.circle.fill"
        case .addRejected:
            return "xmark.circle.fill"
        }
    }
    
    var textLabel: String {
        switch self {
        case .addUpComing:
            return "Add Coming"
        case .addPending:
           return "Add Pending"
        case .addSucceed:
            return "Add Succeed"
        case .addRejected:
            return "Add Rejected"
        }
    }
    
    var addScreenView: some View {
        switch self {
        case .addUpComing:
            return AnyView(AddPendingScreen())
        case .addPending:
           return AnyView(AddPendingScreen())
        case .addSucceed:
            return AnyView(AddPendingScreen())
        case .addRejected:
            return AnyView(AddPendingScreen())
        }
    
    
    }
}

struct AddScreenViewModel_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(AddScreenViewModel.allCases, id: \.self) {
            tab in
            Button {} label: {
                Image(systemName: tab.imageName)
            }
            
        }
    }
}

