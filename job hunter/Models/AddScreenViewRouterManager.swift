//
//  AddScreenViewRouterManager.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/11/23.
//

import Foundation
import SwiftUI

class AddScreenViewRouterManager: ObservableObject {
    @Published var currentScreen: AddScreenViewModel?
    @Published var isSheetPresented: Bool = false
    var view: some View { return currentScreen?.addScreenView }
}


enum AddScreenViewModel: Int, CaseIterable {
    //case addUpComing
    case addPending
    case addSucceed
    case addRejected
    
    var imageName: String {
        switch self {
//        case .addUpComing:
//            return "infinity.circle.fill"
        case .addPending:
           return "hourglass.circle"
        case .addSucceed:
            return "hand.thumbsup.circle"
        case .addRejected:
            return "xmark.circle"
        }
    }
    
    var textLabel: String {
        switch self {
        case .addPending:
           return "Add Pending"
        case .addSucceed:
            return "Add Succeed"
        case .addRejected:
            return "Add Rejected"
        }
    }
    
    var fillColor: Color {
        switch self {
        case .addPending:
            return Color.yellow
        case .addSucceed:
            return Color.green
        case .addRejected:
            return Color.red
        }
    }
//    
    var addScreenView: some View {
        switch self {
//        case .addUpComing:
//            return AnyView(AddPendingScreen())
        case .addPending:
           return AnyView(AddSucceedScreen())
        case .addSucceed:
            return AnyView(AddSucceedScreen())
        case .addRejected:
            return AnyView(AddSucceedScreen())
        }
    
    
    }
}
