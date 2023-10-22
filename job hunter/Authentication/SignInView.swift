//
//  SignInView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/21/23.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    
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
        }
    }
}

#Preview {
    SignInView().environmentObject(AuthenticationModel())
}
