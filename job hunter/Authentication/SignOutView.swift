//
//  SignOutView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/18/23.
//

import SwiftUI

struct SignOutView: View {
    
    @EnvironmentObject var authModel: AuthenticationModel
    var body: some View {
        Button {
            do {
                try AuthenticationManager.sharedAuth.signOutUser()
                authModel.showAuthMainScreen = true
                
            } catch {
                print("sign out error: \(error)")
            }
        } label: {
            Text("Log Out")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(.blue)
                .cornerRadius(20)
        }
    }
}

#Preview {
    SignOutView()
}
