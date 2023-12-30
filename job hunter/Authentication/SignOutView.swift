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
            authModel.signOut()
            
        } label: {
            Text("Sign Out")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: UIScreen.main.bounds.width / 2)
                .background(.blue)
                .cornerRadius(20)
        }
    }
}

#Preview {
    SignOutView()
        .environmentObject(AuthenticationModel())
}
