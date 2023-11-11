//
//  AuthenticationModel.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/22/23.
//

import Foundation


class AuthenticationModel: ObservableObject {
    @Published var showAuthMainScreen: Bool = true
    @Published var userProfile: DBUser? = nil

    func createUserWithEmailAndProfile(email: String, password: String)  async throws {
        //1. create authenticate user: AuthUserResultModel
        let authResult = try await AuthenticationManager.sharedAuth.createUserWithEmailAndPass(email: email, password: password)
        //2. Transform AuthUserResultModel to DB user
        let dbUser = DBUser(user: authResult)
        //3. create user profile and store in firestore
        try await UserManager.shared.createNewUserProfile(user: dbUser)
    }
    
    func signInAndLoadUserProfile(email: String, password: String) async throws {
        let authDataResult = try await AuthenticationManager.sharedAuth.signInWithEmailAndPass(email: email, password: password)
        let result = try await UserManager.shared.getUser(userId: authDataResult.user.uid)
        self.userProfile = result
    }
    
    func loadCurrentUser() async throws -> DBUser? {
        let authResult = try AuthenticationManager.sharedAuth.getAuthenticatedUser()
        let dbUser = try await UserManager.shared.getUser(userId: authResult.uid)
        self.userProfile = dbUser
        return dbUser
    }
}
