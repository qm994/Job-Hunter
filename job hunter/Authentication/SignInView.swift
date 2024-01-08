//
//  SignInView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/22/23.


import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    @EnvironmentObject var authModel: AuthenticationModel

    var body: some View {
        VStack {
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack {
                DefaultTextField(forField: "email", placeholder: "Email", text: $email)
                DefaultTextField(forField: "password", placeholder: "Password", text: $password)
                
                AuthButton(label: "Login") {
                    self.errorMessage = ""
                    self.showError = false
                    Task {
                        do {
                            try await authModel.signInAndLoadUserProfile(
                                email: email,
                                password: password
                            )
                        } catch let signInError {
                            print(signInError)
                            self.errorMessage = authModel.parseFirebaseError(signInError)

                            self.showError = true
                        }
                    }
                }
                if showError {
                    Text("\(errorMessage)")
                        .multilineTextAlignment(.leading)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.red)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}


#Preview {
    SignInView().environmentObject(AuthenticationModel())
}
