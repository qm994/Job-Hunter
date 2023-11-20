//
//  DropdownMenuList.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/14/23.
//

import SwiftUI

struct DropdownMenuList: View {
    
    let options: [DropdownMenuCompanyOption]
    @EnvironmentObject var addInterviewModel: AddInterviewModel
    
    @Binding var isOptionsPresented: Bool
    @Binding var optionSelected: Bool
    
    var body: some View {
        ZStack {
            
            VisualEffectView(effect: UIBlurEffect(style: .regular))
                //.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(options, id: \.id) { option in
                        DropdownMenuOptionRow(
                            option: option,
                            isOptionsPresented: $isOptionsPresented,
                            optionSelected: $optionSelected
                        )
                    }
                }
            } //ScrollView Ends
            /// If all options height > 300, make the container as 300 and use the scroll. Otherwise use the dynamic height
            .frame(height: CGFloat(self.options.count * 30) > 300
                   ? 300
                   : CGFloat(self.options.count * 30)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 2)
            }
        }
        
    }
}

struct DropdownMenuList_Previews: PreviewProvider {
    @State static var isOptionsPresented: Bool = false
    @State static var optionSelected: Bool = false
    static var previews: some View {
        DropdownMenuList(
            options: DropdownMenuCompanyOption.allOptions,
            isOptionsPresented: $isOptionsPresented,
            optionSelected: $optionSelected
        )
        .environmentObject(AddInterviewModel())
    }
}
