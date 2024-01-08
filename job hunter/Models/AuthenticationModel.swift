//
//  AuthenticationModel.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/22/23.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore


class AuthenticationModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userProfile: DBUser? = nil

    func createUserWithEmailAndProfile(email: String, password: String, userName: String)  async throws {
        //1. create authenticate user: AuthUserResultModel
        let authResult = try await AuthenticationManager.sharedAuth.createUserWithEmailAndPass(email: email, password: password)
        //2. Transform AuthUserResultModel to DB user
        let dbUser = DBUser(user: authResult, userName: userName)
        //3. create user profile and store in firestore
        try await UserManager.shared.createNewUserProfile(user: dbUser)
    }
    
    func signInAndLoadUserProfile(email: String, password: String) async throws {
        do {
            let authDataResult = try await AuthenticationManager.sharedAuth.signInWithEmailAndPass(email: email, password: password)
            
            // Attempt to fetch the user profile
            let result = try await UserManager.shared.getUser(userId: authDataResult.user.uid)
            
            // Update the UI on the main thread if the above call is successful
            DispatchQueue.main.async {
                self.isLoggedIn = true
                self.userProfile = result
            }
        } catch {
            // Handle the error here. If this is a UI-related error, make sure to dispatch on the main thread.
            DispatchQueue.main.async {
                // Update any relevant @Published properties or show an error message to the user.
                // For example, setting a "login error" message to be displayed, or updating the UI to reflect the failed login attempt.
                // self.loginErrorMessage = "Failed to sign in and load user profile."
                self.isLoggedIn = false  // Make sure to set this since the login attempt failed.
            }
            // Rethrow the error if you want the caller to handle it as well.
            throw error
        }
    }

    
    func signOut() async throws {
        do {
            try AuthenticationManager.sharedAuth.signOutUser()
            DispatchQueue.main.async {
                self.isLoggedIn = false
                self.userProfile = nil
            }
        } catch let signOutError as NSError {
            throw NSError(domain: "AuthenticationModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Sign out failed with \(signOutError)"])
            // Handle the error (e.g., show an alert to the user)
        }
    }
    
    func resetPassword(email: String) async throws {
        do {
            throw NSError(domain: "AuthenticationModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Password reset failed with customized errors)"])
            try await AuthenticationManager.sharedAuth.resetPassWithEmail(email: email)
        } catch let error {
            throw NSError(domain: "AuthenticationModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Password reset failed with \(error)"])
        }
        
    }
    
    func loadCurrentUser() async throws {
        guard let authResult = try AuthenticationManager.sharedAuth.getAuthenticatedUser() else {
            return
        }
        let dbUser = try await UserManager.shared.getUser(userId: authResult.uid)
        // Dispatch the update of the @Published properties to the main thread
        DispatchQueue.main.async {
            self.isLoggedIn = true
            self.userProfile = dbUser
        }
        //return dbUser
    }
    
    func uploadImageToFirebaseStorage(imageData: Data) async throws -> URL {
        let storageRef = Storage.storage().reference()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthenticationModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])
        }

        let imageRef = storageRef.child("profilePictures/\(userId).jpg")

        do {
            // Upload the image
            let metadata = try await imageRef.putDataAsync(imageData)
           
            // Retrieve and return the download URL
            let url = try await imageRef.downloadURL()
            return url
        } catch {
            throw NSError(domain: "FirebaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to Upload Image To Firebase Storage"])
        }
        
    }

    
    func updateUserPhotoURLInFirestore(photoURL: URL) async throws -> String {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "FirebaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])
        }
        
        do {
            try await db.collection("users").document(userId).updateData(["photoUrl": photoURL.absoluteString])
            return photoURL.absoluteString
        } catch {
            throw NSError(domain: "FirebaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to Update User Photo URL In Firestore"])
        }
    }  
    
    /*
     Delete:
        
        1. document from users collection
        2. user's corresponding interviews documents
        3. user's profile picture
        3. user from Authentication
     */
    
    func batchDeleteUserDocAndMetadata() async throws {
        guard let userProfile = userProfile else {
            throw NSError(domain: "AuthenticationModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user profile found"])
        }
        
        let usersCollection = Firestore.firestore().collection("users")
        let interviewsCollection = Firestore.firestore().collection("interviews")
        let storageRef = Storage.storage().reference().child("profilePictures/\(userProfile.userId).jpg")
        
        // Begin a batch to ensure atomic operations
        let batch = Firestore.firestore().batch()

        do {
            // Reference to the user's document
            let userDocumentRef = usersCollection.document(userProfile.userId)
            // Delete user document
            batch.deleteDocument(userDocumentRef)
            
            // Delete user's all interviews document
            if (userProfile.interviews.count > 0) {
                for interviewId in userProfile.interviews {
                    let interviewDocumentRef = interviewsCollection.document(interviewId)
                    batch.deleteDocument(interviewDocumentRef)
                }
            }
            
            //
            
            
            
            try await batch.commit()
            
            // Attempt to delete the user's profile image from Firebase Storage
            do {
                try await storageRef.delete()
            } catch let storageError as NSError {
                // Check if the error is because the file doesn't exist
                if storageError.domain == StorageErrorDomain && storageError.code == StorageErrorCode.objectNotFound.rawValue {
                    print("Profile image does not exist, no deletion needed.")
                } else {
                    throw storageError
                }
            }
            
            // Delete user Authentication profile
            // Attempt to delete the user from Authentication
            let maxRetries = 3
            for attempt in 1...maxRetries {
                do {
                    try await AuthenticationManager.sharedAuth.deleteUserFromAuthentication()
                    break  // Exit the loop if successful
                } catch {
                    if attempt == maxRetries {
                        // Log this issue for manual intervention and throw error
                        // Consider flagging this user in your database
                        throw NSError(domain: "AuthenticationModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to delete user from Authentication after \(maxRetries) attempts."])
                    }
                    // Optional: wait before retrying
                }
            }
        } catch let error {
            throw error
        }
    }
}

extension AuthenticationModel {
    
    func parseFirebaseError(_ error: Error) -> String {
        let nsError = error as NSError

        // Check for a more specific error message
        if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError,
           let firAuthInternalError = underlyingError.userInfo[NSUnderlyingErrorKey] as? NSError,
           let deserializedResponse = firAuthInternalError.userInfo["FIRAuthErrorUserInfoDeserializedResponseKey"] as? [String: Any],
           let message = deserializedResponse["message"] as? String {

            // Map Firebase error messages to user-friendly messages
            switch message {
            case "INVALID_LOGIN_CREDENTIALS":
                return "The login credentials entered are invalid. Please check and try again."
            // Add other cases as needed
            default:
                return "An unexpected error occurred. Please try again later."
            }
        } else {
            // Fallback error message
            return nsError.localizedDescription
        }
    }

}
