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

    func createUserWithEmailAndProfile(email: String, password: String)  async throws {
        //1. create authenticate user: AuthUserResultModel
        let authResult = try await AuthenticationManager.sharedAuth.createUserWithEmailAndPass(email: email, password: password)
        //2. Transform AuthUserResultModel to DB user
        let dbUser = DBUser(user: authResult)
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

    
    func signOut() {
        do {
            try AuthenticationManager.sharedAuth.signOutUser()
            DispatchQueue.main.async {
                self.isLoggedIn = false
                self.userProfile = nil
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            // Handle the error (e.g., show an alert to the user)
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
            throw NSError(domain: "FirebaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])
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

}

