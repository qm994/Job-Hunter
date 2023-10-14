//
//  DropdownMenuOption.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/14/23.
//

import SwiftUI

struct DropdownMenuOptionRow: View {
    let option: DropdownMenuCompanyOption
    let onSelectedAction: (_ option: DropdownMenuCompanyOption) -> Void
    var body: some View {
        Button {
            print("DropdownMenuOptionRow selected")
        } label: {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "apple.logo")
                Text(option.name)
            }
        }
        .buttonStyle(.plain)
    }
}

struct DropdownMenuOptionRow_Previews: PreviewProvider {
    @State static private var option =  DropdownMenuCompanyOption(name: "Apple")
    static var previews: some View {
        DropdownMenuOptionRow(option: option) { option in
            
        }
    }
}
