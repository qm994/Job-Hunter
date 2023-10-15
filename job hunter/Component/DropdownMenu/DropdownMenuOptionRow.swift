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
    @available(iOS 17.0, *)
    var body: some View {
        DebugView("iOS Version: \(UIDevice.current.systemVersion)")
        Button {
            print("DropdownMenuOptionRow selected")
        } label: {
            HStack(alignment: .center, spacing: 10) {
                if let icon = option.icon {
                    AsyncImageView(url: icon)

                } else {
                    Image(systemName: "building.columns")
                        .symbolRenderingMode(.multicolor)
                }
                
                Text(option.name)
                    .fontWeight(.semibold)
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
