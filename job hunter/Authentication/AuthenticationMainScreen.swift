//
//  AuthenticationMainScreen.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/18/23.
//

import SwiftUI
import UIKit

//
class AuthenticationModel: ObservableObject {
    @Published var showAuthMainScreen: Bool = false
}


struct AuthenticationMainScreen: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    
    @EnvironmentObject var authModel: AuthenticationModel
    
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack {
                    DefaultTextField(forField: "email", placeholder: "Email", text: $email)
                    DefaultTextField(forField: "password", placeholder: "Password", text: $password)
                    
                    AuthButton(label: "Login") {
                        Task {
                            do {
                                try await AuthenticationManager.sharedAuth.signInWithEmailAndPass(
                                    email: self.email,
                                    password: self.password
                                )
                                
                                authModel.showAuthMainScreen = false
                                
                                
                            } catch {
                                print("sign in failed with error: \(error)")
                            }
                        }
                    }
                }
                VStack(spacing: 10) {
                    NavigationLink("No Account? Sign up here") {
                        SignUpEmailView()
                    }
                    NavigationLink("Forgot Password?") {
                        ResetPasswordView()
                    }
                }
            }
        }
    }
}

struct AuthButton: View {
    var label: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(20)
        }
    }
}


#Preview {
    AuthenticationMainScreen()
}
