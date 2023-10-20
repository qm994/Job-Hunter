//
//  NumericInput.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/11/23.
//

import SwiftUI

struct NumericInput: View {
    
    var label: String
    var titleKey: String
   
    @Binding var input: String

    var body: some View {
        
        LabeledContent(label) {
            TextField(titleKey, text: $input)
                .keyboardType(.decimalPad)
                .onChange(of: input) { newValue in
                    filterInput()
                }
                .overlay(
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 2),
                    alignment: .bottom
                )
        }
    }

    func filterInput() {
        input = String(input.filter { "0123456789.".contains($0) })

        // Ensure only one dot is present
        let components = input.split(separator: ".")
        if components.count > 2 {
            input = "\(components[0]).\(components[1])"
        }
    }
}

struct NumericInput_Previews: PreviewProvider {
    @State static var input = "123"
    static var previews: some View {
        HStack {
            NumericInput(
                label: "base pay", titleKey: "annual pay per year", input: $input
            )
        }
    }
}
