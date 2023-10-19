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
    
    func signUp() async {
        
        guard !email.isEmpty, !password.isEmpty else {
            print("emial or password cannot be empty")
            return
        }
        do {
            let result = try await AuthenticationManager.sharedAuth.createUserWithEmailAndPass(
                email: email, password: password
            )
            print(result)
        } catch {
            print("error is \(error)")
        }
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
                    await model.signUp()
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
        .navigationTitle("Sign Up With Email & Password")
    }
}

#Preview {
    
    struct WrapperView: View {
        
        var body: some View {
            SignUpEmailView()
        }
    }
    
    return WrapperView()
}
