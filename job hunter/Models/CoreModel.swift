//
//  CoreModel.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/11/23.
//

import Foundation


class CoreModel: ObservableObject {
    @Published var selectedTab: BottomNavigationModel = .home
}
