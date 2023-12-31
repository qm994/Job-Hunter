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
    @Published var username: String = ""
    
    
    @Published private(set) var errorMessage: String? = nil
    
    private var authModel: AuthenticationModel
    
    init(authModel: AuthenticationModel) {
        self.authModel = authModel
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty, !username.isEmpty else {
            self.errorMessage = "Email, Password, Username are required!"
            return
        }
        
        do {
            try await authModel.createUserWithEmailAndProfile(
                email: email, password: password
            )
        } catch {
            self.errorMessage = error.localizedDescription
            throw error
        }
        
    }
}

struct SignUpEmailView: View {
    @StateObject private var authModel: AuthenticationModel
    @StateObject private var model: SignUpViewModel
    @State private var showAlert: Bool = false
    
    // Initialize SignUpViewModel with AuthenticationModel so we can use AuthenticationModel's method in SignUpViewModel
    
    init() {
        let authModel = AuthenticationModel()
        self._authModel = StateObject(wrappedValue: authModel)
        self._model = StateObject(wrappedValue: SignUpViewModel(authModel: authModel))
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
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
            
            CustomizedTextField(
                label: "Username *",
                fieldPlaceHolder: "ex: jonhn_doe",
                fieldValue: $model.username,
                isVerticalDivider: false
            )
            
            
            AuthButton(label: "Sign Up") {
                Task {
                    do {
                        try await model.signUp()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        showAlert = true
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(model.errorMessage ?? "Unknown error"),
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
