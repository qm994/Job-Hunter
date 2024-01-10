//
//  FirebaseServices.swift
//  job hunter
//
//  Created by Qingyuan Ma on 1/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

final class FirebaseServices {
    static let shared = FirebaseServices()
    let firestore: Firestore
    let auth: Auth
    let storage: Storage
    
    private init() {
        let firestoreInstance = Firestore.firestore()
        #if DEBUG
        print("running on emulator")
        let settings = firestoreInstance.settings
        settings.host = "127.0.0.1:8080" // Set this to your emulator host and port
        settings.isSSLEnabled = false
        settings.cacheSettings = MemoryCacheSettings() // Customize this as needed
        firestoreInstance.settings = settings
        
        // Configure Firebase to use the Auth emulator in Debug mode
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        Storage.storage().useEmulator(withHost: "localhost", port: 9199)
        #endif
        self.firestore = firestoreInstance
        self.auth = Auth.auth()
        self.storage = Storage.storage()
    }
}
