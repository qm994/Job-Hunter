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

    // Encode the RoundModel to match pastRounds sub collection doc.
    func encodeRoundModels(roundModels: [RoundModel]) throws -> [[String: Any]] {
        let encoder = Firestore.Encoder()
        let encodedRounds = try roundModels.map { try encoder.encode($0) }
        return encodedRounds
    }
    
    private func updateDataWithRounds(user: DBUser, data: inout [String: Any], pastRounds: [RoundModel], futureRounds: [RoundModel]) throws -> [String: Any] {
        // Reference to the users collection and the specific user document
        let userReference = UserManager.shared.userDocument(userId: user.userId)
        data["user_id"] = userReference
        // Encode the rounds and add them to the data dictionary
        let encodedPastRounds = try encodeRoundModels(roundModels: pastRounds)
        let encodedFutureRounds = try encodeRoundModels(roundModels: futureRounds)
        data["pastRounds"] = encodedPastRounds
        data["futureRounds"] = encodedFutureRounds
        return data
    }
    
    //TODO:
    func updateInterview(user: DBUser, data: inout [String: Any], pastRounds: [RoundModel], futureRounds: [RoundModel], interviewId: String?) async throws {
        guard let interviewId = interviewId else {
            throw NSError(domain: "AddInterviewManager", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Cannot find updating interview."])
        }
        let userReference = UserManager.shared.userDocument(userId: user.userId)
        let data = try updateDataWithRounds(user: user, data: &data, pastRounds: pastRounds, futureRounds: futureRounds)
        
        let interviewRef = interviewCollection.document(interviewId)
        let document = try await interviewRef.getDocument()
        if document.exists {
            try await interviewRef.updateData(data)
        }
    }
    
    
    // Create interview and store its refernece to User in FireStore
    func createInterview(user: DBUser, data: inout [String: Any], pastRounds: [RoundModel], futureRounds: [RoundModel]) async throws -> DocumentReference {
        let userReference = UserManager.shared.userDocument(userId: user.userId)
        let data = try updateDataWithRounds(user: user, data: &data, pastRounds: pastRounds, futureRounds: futureRounds)

        let newInterviewDocRef = interviewCollection.document()
        
        // 1. Create interview
        try await newInterviewDocRef.setData(data)
        // 2. Connect interview and user: Add interview document_id to the User's interviews array field
        try await addInterviewReferenceToUser(userRef: userReference, interviewId: newInterviewDocRef.documentID)
        return newInterviewDocRef
        
    }
}
