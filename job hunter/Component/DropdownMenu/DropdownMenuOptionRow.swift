//
//  DropdownMenuOption.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/14/23.
//

import SwiftUI

struct DropdownMenuOptionRow: View {
    let option: DropdownMenuCompanyOption
    @EnvironmentObject var addInterviewModel: AddInterviewModel
    
    @Binding var isOptionsPresented: Bool
    @Binding var optionSelected: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if let icon = option.logo {
                AsyncImageView(url: icon)

            } else {
                Image(systemName: "building.columns")
                    .symbolRenderingMode(.multicolor)
            }
            
            Text(option.name)
                .fontWeight(.semibold)
        }
        .onTapGesture {
            withAnimation {
                isOptionsPresented = false
                optionSelected = true
                let selectedCompany = Company(name: option.name, logo: option.logo)
                addInterviewModel.company = selectedCompany
            }
        }
    }
}

struct DropdownMenuOptionRow_Previews: PreviewProvider {
    @State static private var option =  DropdownMenuCompanyOption(name: "Apple")
    @State static var isOptionsPresented: Bool = false
    @State static var optionSelected: Bool = false
    static var previews: some View {
        DropdownMenuOptionRow(
            option: option,
            isOptionsPresented: $isOptionsPresented,
            optionSelected: $optionSelected
        )
        .environmentObject(AddInterviewModel())
    }
}
