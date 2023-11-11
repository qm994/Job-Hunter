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
    
    func addInterviewReferenceToUser(userRef: DocumentReference, interviewId: String) async throws {
        try await userRef.updateData(["interviews": FieldValue.arrayUnion([interviewId])])
    }
    
    // Create interview and store its refernece to User in FireStore
    func createInterview(user: DBUser, data: inout [String: Any]) async throws {
        // Reference to the users collection and the specific user document
        let userReference = UserManager.shared.userDocument(userId: user.userId)
        data["user_id"] = userReference
        let newInterviewDocRef = interviewCollection.document()
        
        // 1. Create interview
        try await newInterviewDocRef.setData(data)
        // 2. Add interview document id to the User's interviews array field
        return try await addInterviewReferenceToUser(userRef: userReference, interviewId: newInterviewDocRef.documentID)
    }
}
