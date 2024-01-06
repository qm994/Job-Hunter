//
//  SignOutView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/18/23.
//

import SwiftUI

struct ActionButton: View {
    let action: () -> Void
    let text: String
    let role: String

    init(text: String, role: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.role = role
    }
    
    private var backgroundColor: Color {
        switch role {
            case "destructive":
                return Color(.red)
            default:
                return Color(.blue)
        }
    }

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: UIScreen.main.bounds.width / 2)
                .background(backgroundColor) // Typically, destructive buttons are red
                .cornerRadius(20)
        }
    }
}


#Preview {
    ActionButton(text: "sign out", role: "destructive") {
        
    }
}
