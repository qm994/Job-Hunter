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
    
    //
    var isPremium: Bool
    
    var maxInterviewsAllowed: Int
    var userName: String
    
    init(user: AuthUserResultModel, userName: String) {
        self.userId = user.uid
        self.dateCreated = Date()
        self.dateModified = Date()
        self.email = user.email
        self.photoUrl = user.photoUrl
        // Initialize the interview references as an empty array
        self.interviews = []
        self.isPremium = false
        self.maxInterviewsAllowed = 5
        self.userName = userName
    }
}

// UserManager used to access the `users` collection
final class UserManager {

    static let shared = UserManager()
    
    init() {}
    
    private var usersCollection: CollectionReference {
        FirebaseServices.shared.firestore.collection("users")
    }
    
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
        do {
            let document = try await userDocument(userId: userId).getDocument()
            if let data = document.data(), document.exists {
                return try userDecoder.decode(DBUser.self, from: data as Any)
            } else {
                // Handle the scenario where the user doesn't exist.
                throw NSError(domain: "UserManager", code: 0, userInfo: ["description": "No user document found!"])
            }
        } catch {
            throw NSError(domain: "UserManager", code: 1, userInfo: ["description": "Error fetching user: \(error.localizedDescription)"])
        }
    }
    
    //
}
