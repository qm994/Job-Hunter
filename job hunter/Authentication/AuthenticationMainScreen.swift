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
                    Button {
                        Task {
                            do {
                                
                                let result = try await AuthenticationManager.sharedAuth.signInWithEmailAndPass(
                                    email: self.email,
                                    password: self.password
                                )
                                
                                authModel.showAuthMainScreen = false
                                print("sign in succeed with user: \(result.user)")
                                
                            } catch {
                                print("sign in failed with error: \(error)")
                            }
                        }
                    } label: {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(.blue)
                            .cornerRadius(20)
                    }
                }
                
                NavigationLink("No Account? Sign up here") {
                    SignUpEmailView()
                }
                
            }
        }
    }
}

#Preview {
    AuthenticationMainScreen()
}
