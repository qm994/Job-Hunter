//
//  UserManager.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/22/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser {
    let userId: String
    let dateCreated: Date?
    let dateModifiedd: Date?
    let email: String?
    let photoUrl: String?
}

final class UserManager {

    static let shared = UserManager()

    init() {}
    ///When signup the user, createNewUserProfile() store the user document in users collection
    func createNewUserProfile(authUser: AuthUserResultModel) async throws {
        var documentData: [String: Any] = [
            "user_id": authUser.uid,
            "date_created": Timestamp(),
            "date_modified": Timestamp()
        ]

        if let email = authUser.email {
            documentData["email"] = email
        }

        if let photoUrl = authUser.photoUrl {
            documentData["photo_url"] = photoUrl
        }
        try await Firestore.firestore().collection("users").document(authUser.uid).setData(documentData, merge: false)
    }

    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()

        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }

        let email = data["email"] as? String
        let dateCreated = data["date_created"] as? Date
        let dateModifiedd = data["date_modified"] as? Date
        let photoUrl = data["photo_url"] as? String

        return DBUser(
            userId: userId,
            dateCreated: dateCreated,
            dateModifiedd: dateModifiedd,
            email: email,
            photoUrl: photoUrl
        )

    }
}
