//
//  AuthenticationModel.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/22/23.
//

import Foundation


class AuthenticationModel: ObservableObject {
    @Published var showAuthMainScreen: Bool = false

    func createUserWithEmailAndProfile(email: String, password: String)  async throws {
        //1. create authenticate user
        let authResult = try await AuthenticationManager.sharedAuth.createUserWithEmailAndPass(email: email, password: password)
        //2. create user profile and store in db
        try await UserManager.shared.createNewUserProfile(authUser: authResult)
    }
}
