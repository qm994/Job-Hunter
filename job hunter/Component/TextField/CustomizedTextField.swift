//
//  CustomizedTextField.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/15/23.
//

import SwiftUI

struct CustomizedTextField: View {
    
    @EnvironmentObject var addInterviewModel: AddInterviewModel
    
    
    
    let screenWidth = UIScreen.main.bounds.width
    
    var label: String
    var fieldPlaceHolder: String
    @Binding var fieldValue: String
    var isVerticalDivider: Bool = false
    
    var showBorderWarning: Bool = false
    
    var onChangeAction:  (() -> Void)?
    
    var body: some View {
        HStack {
            //MARK: LABEL + DIVIDER
            Text(label)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Spacer()
            
            TextField(fieldPlaceHolder, text: $fieldValue)
                .autocapitalization(.none)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .onChange(of: fieldValue) { _ in
                    if let action = onChangeAction {
                        action()
                    }
                }
            
        }
        .padding()
        .frame(height: 50)
        .overlay(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(showBorderWarning ? .red : .gray, lineWidth: 4)
        }
        .cornerRadius(10)
    }
}

#Preview() {
    @State var value: String = ""
    return   CustomizedTextField(
        label: "Company *",
        fieldPlaceHolder: "ex: Apple",
        fieldValue: $value
    )
    .environmentObject(AddInterviewModel())
    
}
