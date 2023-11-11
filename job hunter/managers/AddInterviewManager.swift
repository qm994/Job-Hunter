//
//  AddInterviewManager.swift
//  job hunter
//
//  Created by Qingyuan Ma on 11/7/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// Singleton interface to control the creation of interview
final class AddInterviewManager {
    static let shared = AddInterviewManager()
    init(){}
    
    private let interviewCollection = Firestore.firestore().collection("interviews")
    
    //
    func createInterview(user: DBUser, data: inout [String: Any]) async throws {
        // Reference to the users collection and the specific user document
        let userReference = UserManager.shared.userDocument(userId: user.userId)
        data["user_id"] = userReference
        print("createInterview data: \(data)")
        return try await interviewCollection.document().setData(data)
    }
}
