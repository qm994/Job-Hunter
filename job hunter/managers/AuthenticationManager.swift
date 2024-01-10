//
//  AuthenticationManager.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/22/23.
//

import FirebaseAuth
import Foundation


struct AuthUserResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}


// Singleton interface controls all direct api access to Firebase use FirebaseAuth methods
final class AuthenticationManager {
    static var sharedAuth = AuthenticationManager()
    
    

    private init() {}

    func getAuthenticatedUser() throws -> AuthUserResultModel? {
        guard let user = FirebaseServices.shared.auth.currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthUserResultModel(user: user)
    }


    @discardableResult
    func createUserWithEmailAndPass(email: String, password: String) async throws -> AuthUserResultModel {
        let authResult = try await FirebaseServices.shared.auth.createUser(withEmail: email, password: password)
        return AuthUserResultModel(user: authResult.user)
    }

    @discardableResult
    func signInWithEmailAndPass(email: String, password: String) async throws -> AuthDataResult {
        return try await FirebaseServices.shared.auth.signIn(withEmail: email, password: password)
    }

    func signOutUser() throws  {
        return try FirebaseServices.shared.auth.signOut()
    }
    
    

    func resetPassWithEmail(email: String) async throws {
        return try await FirebaseServices.shared.auth.sendPasswordReset(withEmail: email)
    }
    
    func deleteUserFromAuthentication() async throws {
        guard let user = FirebaseServices.shared.auth.currentUser else {
            throw NSError(domain: "AuthenticationManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"])
        }
        do {
            try await user.delete()
        } catch let error {
            throw NSError(domain: "AuthenticationManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to delete user: \(error.localizedDescription)"])
        }
    }
  
}
