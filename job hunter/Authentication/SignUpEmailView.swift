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
            
            Button {
                Task {
                    do {
                        try await model.signUp()
                    } catch {
                        print("sign up failed: \(error)")
                    }
                }
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(.blue)
                    .cornerRadius(20)
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
