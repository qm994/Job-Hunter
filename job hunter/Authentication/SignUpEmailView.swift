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
    
    
    private var authModel: AuthenticationModel
    
    init(authModel: AuthenticationModel) {
        self.authModel = authModel
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty, !username.isEmpty else {
            
            throw NSError(domain: "SignUpViewModel", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Email, Password, Username are required!"])
        }
        
        do {
            try await authModel.createUserWithEmailAndProfile(
                email: email, password: password, userName: username
            )
        } catch {
            throw NSError(domain: "SignUpViewModel", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Create user failed! Please try again later and contact the developer at: ma791778711@gmail.com."])
        }
        
    }
}

struct SignUpEmailView: View {
    @StateObject private var authModel: AuthenticationModel
    @StateObject private var model: SignUpViewModel
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    
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
                        self.showAlert = true
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK")) {
                        model.email = ""
                        model.password = ""
                        model.username = ""
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
