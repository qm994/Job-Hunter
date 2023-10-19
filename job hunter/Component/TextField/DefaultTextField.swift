//
//  DefaultTextField.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/18/23.
//

import SwiftUI

struct DefaultTextField: View {
    var forField: String?
    var placeholder: String
    @Binding var text: String
    @State private var isSecure: Bool
    
    
    // Update the init method to accept all required parameters
    init(forField: String?, placeholder: String, text: Binding<String>) {
        self.forField = forField
        self.placeholder = placeholder
        self._text = text
        self._isSecure = State(initialValue: forField == "password")  // Set the initial value of isSecure based on forField
    }

    
    func toggle () {
        isSecure.toggle()
    }

    var body: some View {
        HStack {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
            if forField == "password" {
                Button(action: {
                    toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(isSecure ? .gray : .blue)
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(UIColor.systemGray3), lineWidth: 1)
        )
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    struct Wrapper: View {
        @State var text = "asxaxaxa"
        var body: some View {
            DefaultTextField(forField: "password", placeholder: "password", text: $text)
        }
    }
    return Wrapper()
}
