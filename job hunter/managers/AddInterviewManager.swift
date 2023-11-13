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

    
    func encodeRoundModels(roundModels: [RoundModel]) {
        let encoder = Firestore.Encoder()
        do {
            let encodedRounds = try roundModels.map { try encoder.encode($0) }
            print("encodedRounds are: \(encodedRounds)")
            // Now `encodedRounds` is an array of dictionaries with the encoded round data
        } catch {
            print(error)
        }

    }
    
    // TODO: func of add the encoded past rounds to firestore
    
    // Add pastRounds subCollection to interview document
    func addPastRoundsToInterview(interviewDocumentId: String, pastRounds: [RoundModel]) async throws {
        let pastRoundsCollection = interviewCollection.document(interviewDocumentId).collection("pastRounds")
        let pastRoundsDocs = pastRoundsCollection.document()
        
        let pastRoundsData: [String: Any] = [
            "date": Timestamp(date: Date()), // Use Timestamp for Firestore date fields
            "name": "HR Call",
            "notes": "notes for the round of interview",
            "description": "",
            "last_time": 60
        ]
        
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
