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
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthUserResultModel(user: user)
    }


    @discardableResult
    func createUserWithEmailAndPass(email: String, password: String) async throws -> AuthUserResultModel {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthUserResultModel(user: authResult.user)
    }

    @discardableResult
    func signInWithEmailAndPass(email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signOutUser() throws  {
        return try Auth.auth().signOut()
    }
    
    

    func resetPassWithEmail(email: String) async throws {
        return try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    
}
