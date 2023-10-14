//
//  DropdownMenuList.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/14/23.
//

import SwiftUI

struct DropdownMenuList: View {
    
    let options: [DropdownMenuCompanyOption]
    
    
    //let onLoadDataWhenChange: (_ query: String) -> Void
    
    /// An action called when user select an action.
    let onSelectedAction: (_ option: DropdownMenuCompanyOption) -> Void

    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(options, id: \.id) { option in
                    DropdownMenuOptionRow(
                        option: option,
                        onSelectedAction: onSelectedAction
                    )
                }
            }
        }
        /// If all options height > 300, make the container as 300 and use the scroll. Otherwise use the dynamic height
        .frame(height: CGFloat(self.options.count * 30) > 300
               ? 300
               : CGFloat(self.options.count * 30)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray, lineWidth: 2)
        }
        .background(.orange)
    }
}

struct DropdownMenuList_Previews: PreviewProvider {
    static var previews: some View {
        DropdownMenuList(options: DropdownMenuCompanyOption.allOptions) { option in
            
        }
    }
}
