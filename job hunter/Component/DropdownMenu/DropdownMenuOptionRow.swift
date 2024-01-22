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
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 16) {
                iconView(geometry: geometry)
                Text(option.name)
                    .fontWeight(.bold)
                    .font(.headline) // Increase the font size here
                    .padding(.leading, 8) // Add some padding if needed
                Spacer()
            }
            //.frame(width: geometry.size.width, height: geometry.size.height)
            .padding(.vertical) // Add vertical padding to increase the height of each row
            .onTapGesture {
                withAnimation {
                    isOptionsPresented = false
                    optionSelected = true
                    let selectedCompany = Company(name: option.name, logo: option.logo)
                    addInterviewModel.company = selectedCompany
                }
            }
            .frame(maxWidth: .infinity) 
            
        } // GeometryReader ends
    }
    
    @ViewBuilder
    private func iconView (geometry: GeometryProxy) -> some View {
        Group {
            if let icon = option.logo {
                //DebugView("url is \(icon)")
                AsyncImageView(url: icon) {
                    ProgressView()
                }
            } else {
                Image(systemName: "building.columns")
                    .symbolRenderingMode(.multicolor)
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.6)
    }
}

struct DropdownMenuOptionRow_Previews: PreviewProvider {
    @State static private var option =  DropdownMenuCompanyOption(name: "Microsoft", icon: "https://logo.clearbit.com/microsoft.com")
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
