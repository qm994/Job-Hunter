//
//  DropdownMenuList.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/14/23.
//

import SwiftUI

struct DropdownMenuList: View {
    @EnvironmentObject var addInterviewModel: AddInterviewModel
    @EnvironmentObject var clearbitModel: ClearbitViewModel
    
    @Binding var isOptionsPresented: Bool
    @Binding var optionSelected: Bool

    var body: some View {
        GeometryReader { geometry in
            contentView(geometry: geometry)
        }
    }

    @ViewBuilder
    private func contentView(geometry: GeometryProxy) -> some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .regular))
            optionsView(geometry: geometry)
        }
    }

    @ViewBuilder
    private func optionsView(geometry: GeometryProxy) -> some View {
        if let options = clearbitModel.companyList {
            ScrollView {
                optionsListView(options, geometry: geometry)
            }
            .frame(height: 300)
            .overlay {
                RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 2)
            }
        }
    }

    @ViewBuilder
    private func optionsListView(_ options: [DropdownMenuCompanyOption], geometry: GeometryProxy) -> some View {
        DebugView("height is: \(geometry.size.height) and count is: \(options.count)")
        LazyVStack(alignment: .leading) {
            ForEach(options, id: \.id) { option in
                DropdownMenuOptionRow(
                    option: option,
                    isOptionsPresented: $isOptionsPresented,
                    optionSelected: $optionSelected
                )
                .frame(height: CGFloat(300) / CGFloat(options.count))
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}

struct DropdownMenuList_Previews: PreviewProvider {
    @State static var isOptionsPresented: Bool = false
    @State static var optionSelected: Bool = false
    static var previews: some View {
        DropdownMenuList(
            isOptionsPresented: $isOptionsPresented,
            optionSelected: $optionSelected
        )
        .environmentObject(AddInterviewModel())
        .environmentObject(ClearbitViewModel())
    }
}
