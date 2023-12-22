//
//  UserManager.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/22/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


//TODO: USE CUSTOM ENCODING AND DECODING KEYS 

struct DBUser: Codable {
    let userId: String
    let dateCreated: Date?
    let dateModified: Date?
    let email: String?
    var photoUrl: String?
    
    // Array to store references to the user's interviews
    var interviews: [String]
    
    init(user: AuthUserResultModel) {
        self.userId = user.uid
        self.dateCreated = Date()
        self.dateModified = Date()
        self.email = user.email
        self.photoUrl = user.photoUrl
        // Initialize the interview references as an empty array
        self.interviews = []
    }
}

// UserManager used to access the `users` collection
final class UserManager {

    static let shared = UserManager()
    
    init() {}
    
    private let usersCollection = Firestore.firestore().collection("users")
    
    func userDocument(userId: String) -> DocumentReference {
        usersCollection.document(userId)
    }
    
    // Encoder will encode the DBUser and transform its keys from camelcase to snakecase in firestore
    private let userEncoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    // Signup the user, createNewUserProfile() store the user document in users collection
    func createNewUserProfile(user: DBUser) async throws {
        try await userDocument(userId: user.userId)
            .setData(from: user, merge: false, encoder: userEncoder)
    }
    
    
    private let userDecoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // Authenticated user profile from firestore
    func getUser(userId: String) async throws -> DBUser? {
        let document = try await userDocument(userId: userId).getDocument()
        if document.exists {
            return try userDecoder.decode(DBUser.self, from: document.data() as Any)
        } else {
            // Handle the scenario where the user doesn't exist.
            return nil
        }
    }
    
    //
}
