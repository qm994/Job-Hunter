//
//  SettingsView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 1/2/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authModel: AuthenticationModel
    @EnvironmentObject var coreModel: CoreModel
    @State var showError = false
    @State var errorMessage: String = ""
    @State private var isOperationInProgress = false
    
    var body: some View {
        //TODO: ADD DELETE ACCOUNT
        ZStack {
            VStack(spacing: 20) {
                ActionButton(text: "Sign out", role: "primary") {
                    Task {
                        do {
                            try await authModel.signOut()
                            // Reset navigation state
                            DispatchQueue.main.async {
                                coreModel.path = [] // Clears the navigation stack
                                coreModel.selectedTab = .home // Sets the selected tab to home
                            }
                            
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                    }
                }
                ActionButton(text: "Reset password", role: "primary") {
                    coreModel.path.append(NavigationPath.resetPasswordView.rawValue)
                }
                ActionButton(text: "Delete Account", role: "destructive") {
                    isOperationInProgress = true
                    
                    Task {
                        do {
                            try await authModel.batchDeleteUserDocAndMetadata()
                            
                            DispatchQueue.main.async {
                                authModel.userProfile = nil
                                authModel.isLoggedIn = false
                            }
                        } catch let deleteError {
                            DispatchQueue.main.async {
                                errorMessage = deleteError.localizedDescription
                                showError = true
                            }
                        }
                        
                        DispatchQueue.main.async {
                            isOperationInProgress = false
                        }
                    }
                }
            } //vstack ends
            if isOperationInProgress {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
        } //zstack ends
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK")) {
                    errorMessage = ""
                }
            )
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthenticationModel())
        .environmentObject(CoreModel())
}
