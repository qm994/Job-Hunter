//
//  ResetPasswordView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/20/23.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var resetEmail: String = ""
    @State private var showAlert: Bool = false
    
    @EnvironmentObject var authModel: AuthenticationModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            DefaultTextField(forField: "email", placeholder: "Email used before", text: $resetEmail)
            
            AuthButton(label: "Send reset link") {
                Task {
                    guard !resetEmail.isEmpty else {
                        print("")
                        return
                    }
                
                    do {
                        try await AuthenticationManager.sharedAuth.resetPassWithEmail(email: resetEmail)
                        
                        presentationMode.wrappedValue.dismiss()
                        
                    } catch {
                        showAlert = true
                    }
                }
            }
            .onAppear {
                if let email = authModel.userProfile?.email {
                    resetEmail = email
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Something went wrong! Please try again later"),
                    dismissButton: .default(Text("OK")) {
                        // Optionally reset state or perform other actions when the alert is dismissed
                        resetEmail = ""
                    }
                )
            }
        }
        .navigationBarTitle("Reset Password", displayMode: .inline)
    }
}

#Preview {
    ResetPasswordView()
}
