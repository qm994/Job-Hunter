//
//  FirestoreInterviewDataManager.swift
//  job hunter
//
//  Created by Qingyuan Ma on 11/22/23.
//

import Foundation
import FirebaseFirestore


class FirestoreInterviewDataManager {
    
    static let shared = FirestoreInterviewDataManager()
    
    private var usersCollection: CollectionReference {
        FirebaseServices.shared.firestore.collection("users")
    }
    private var interviewsCollection: CollectionReference {
        FirebaseServices.shared.firestore.collection("interviews")
    }
    
    init(){}
    
    func fetchUserInterviewIDs(userID: String) async throws -> [String] {
        // Fetch the user document from Firestore using the userID
        // Extract the 'interviews' field which is an array of interview document IDs
        // Return the array of IDs
        let userDocument = try await usersCollection.document(userID).getDocument().data()
        
        guard let interviewIDs = userDocument?["interviews"] as? [String] else {
            throw NSError(domain: "FirestoreInterviewDataManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Interviews field is missing or not an array of strings. Please contact the admin."])
        }
        return interviewIDs
        
    }
    
    // Fetch each interview document using the interviewIDs
    // Parse them into an array of Interview models
    
    func fetchInterviews(fromUser userId: String?) async throws -> [DocumentSnapshot]? {
        guard let userId = userId else {
            throw NSError(domain: "FirestoreInterviewDataManager", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Cannot find the user profile..."])
        }
        
        let interviewIDs = try await fetchUserInterviewIDs(userID: userId)
         
        if interviewIDs.isEmpty {
            return nil
        }

        // Split the array into chunks of 10 to conform to Firestore's limitation
        let chunks = interviewIDs.chunked(into: 10)
        
        var allInterviewDocuments = [DocumentSnapshot]()

        for chunk in chunks {
            do {
                let querySnapshot = try await interviewsCollection.whereField(FieldPath.documentID(), in: chunk).getDocuments()
                allInterviewDocuments.append(contentsOf: querySnapshot.documents)
            } catch let error {
                throw error
            }
        }
        
        return allInterviewDocuments
    }
    
    func deleteInterview(from userId: String, with interviewId: String) async throws {
        // Begin a batch to ensure atomic operations
        let batch = FirebaseServices.shared.firestore.batch()

        // Reference to the user's document
        let userDocumentRef = usersCollection.document(userId)


        // Remove the interview ID from the user's document
        batch.updateData(["interviews": FieldValue.arrayRemove([interviewId])], forDocument: userDocumentRef)

        // Reference to the interview document
        let interviewDocumentRef = interviewsCollection.document(interviewId)

        // Delete the interview document
        batch.deleteDocument(interviewDocumentRef)

        // Commit the batch
        try await batch.commit()
    }

}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, self.count)])
        }
    }
}
