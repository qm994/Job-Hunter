//
//  SignInEmailView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/17/23.
//

import SwiftUI

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("emial or password cannot be empty")
            return
        }
        
        try await AuthenticationManager.sharedAuth.createUserWithEmailAndPass(
            email: email, password: password
        )
    }
}

struct SignUpEmailView: View {
    @StateObject var model = SignUpViewModel()
    @State private var showAlert: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        DebugView("redraw!!!")
        VStack {
            CustomizedTextField(
                label: "Email *", 
                fieldPlaceHolder: "Type Email...",
                fieldValue: $model.email,
                isVerticalDivider: false
            )
            
            CustomizedTextField(
                label: "Password *",
                fieldPlaceHolder: "Type password...",
                fieldValue: $model.password,
                isVerticalDivider: false
            )
            
            AuthButton(label: "Sign Up") {
                Task {
                    do {
                        try await model.signUp()
                    } catch {
                        showAlert = true
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK")) {
                        model.email = ""
                        model.password = ""
                    }
                )
            }
        }
        .navigationTitle("Sign Up")
    }
}

#Preview {
    
    struct WrapperView: View {
        
        var body: some View {
            NavigationStack {
                SignUpEmailView()
            }
        }
    }
    
    return WrapperView()
}
