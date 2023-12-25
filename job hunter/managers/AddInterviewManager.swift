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
    
//    // Add Encoded PastRounds subCollection to interview document
//    func addPastRounds(to interviewDocumentId: String, pastRounds: [RoundModel]) async throws {
//        let pastRoundsCollection = interviewCollection.document(interviewDocumentId).collection("pastRounds")
//        let encodedPastRounds = try encodeRoundModels(roundModels: pastRounds)
//        
//        for encodedRound in encodedPastRounds {
//            let pastRoundDoc = pastRoundsCollection.document() // Create a new document reference
//            try await pastRoundDoc.setData(encodedRound) // Add the encoded round as a new document
//        }
//    }
//    
//    //TODO: Merge addFutureRounds and addPastRounds to one function
//    
//    // Add Encoded FutureRounds subCollection to interview document
//    func addFutureRounds(to interviewDocumentId: String, futureRounds: [RoundModel]) async throws {
//        let futureRoundsCollection = interviewCollection.document(interviewDocumentId).collection("futureRounds")
//        let encodedFutureRounds = try encodeRoundModels(roundModels: futureRounds)
//        
//        for encodedRound in encodedFutureRounds {
//            let futureRoundDoc = futureRoundsCollection.document() // Create a new document reference
//            try await futureRoundDoc.setData(encodedRound) // Add the encoded round as a new document
//        }
//    }
    
    
    
    // Create interview and store its refernece to User in FireStore
    func createInterview(user: DBUser, data: inout [String: Any], pastRounds: [RoundModel], futureRounds: [RoundModel]) async throws -> DocumentReference {
        // Reference to the users collection and the specific user document
        let userReference = UserManager.shared.userDocument(userId: user.userId)
        data["user_id"] = userReference
        // Encode the rounds and add them to the data dictionary
        let encodedPastRounds = try encodeRoundModels(roundModels: pastRounds)
        let encodedFutureRounds = try encodeRoundModels(roundModels: futureRounds)
        data["pastRounds"] = encodedPastRounds
        data["futureRounds"] = encodedFutureRounds

        let newInterviewDocRef = interviewCollection.document()
        
        // 1. Create interview
        try await newInterviewDocRef.setData(data)
        // 2. Connect interview and user: Add interview document_id to the User's interviews array field
        try await addInterviewReferenceToUser(userRef: userReference, interviewId: newInterviewDocRef.documentID)
        return newInterviewDocRef
        
    }
}
