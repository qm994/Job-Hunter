//
//  DropdownMenu.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/14/23.
//

import SwiftUI


struct DropdownMenuCompanyOption: Identifiable {
    let id = UUID().uuidString
    let name: String
    let logo: String?
    
    init(name: String, icon: String? = nil) {
        self.name = name
        self.logo = icon
    }
}


extension DropdownMenuCompanyOption {
    static let allOptions: [DropdownMenuCompanyOption] = [
        DropdownMenuCompanyOption(name: "Apple"),
        DropdownMenuCompanyOption(name: "Applepie"),
        DropdownMenuCompanyOption(name: "Appal"),
        DropdownMenuCompanyOption(name: "Apple"),
        DropdownMenuCompanyOption(name: "Applepie"),
        DropdownMenuCompanyOption(name: "Appal"),
        DropdownMenuCompanyOption(name: "Apple"),
        DropdownMenuCompanyOption(name: "Applepie"),
        DropdownMenuCompanyOption(name: "Appal"),
        DropdownMenuCompanyOption(name: "Apple"),
        DropdownMenuCompanyOption(name: "Applepie"),
        DropdownMenuCompanyOption(name: "Appal")
    ]
}



struct DropdownMenu: View {
    
    var options: [DropdownMenuCompanyOption]?
    var dropDownLabel: String
   
    @ObservedObject var sharedData: AddInterviewModel
    
    
    @State private var isOptionsPresented: Bool = false
    @State private var selectedOption: DropdownMenuCompanyOption? = nil
    @State private var optionSelected: Bool = false
    /// this is called when bind value with TextField change and it act as the loader of autocomplete
    var onLoadDataWhenChange: (_ query: String) -> Void
    
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            Text(dropDownLabel)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Spacer()
            TextField(selectedOption == nil ? "ex: Microsoft" : selectedOption!.name, text: $sharedData.company.name)
                .autocapitalization(.none)
                .fontWeight(.medium)
                .foregroundColor(selectedOption == nil ? .gray : .black)
                .frame(maxWidth: .infinity)
                .onChange(of: sharedData.company.name, initial: false) { _, newValue in
                    //optionSelected: without this check, whenever we tap a option, the sharedData.company.name will change, then cause isOptionsPresented = true. So the dropdown wont be closed
                    if !optionSelected {
                        onLoadDataWhenChange(newValue)
                        print("called after debounce")
                        isOptionsPresented = true
                    } else {
                        optionSelected = true
                    }
                }
            ///Add logo to the textfield
                .overlay(
                    Group {
                        if let logoURL = sharedData.company.logo {
                            AsyncImageView(url: logoURL)
                        }
                    }, alignment: .trailing
                )
            
            
            Spacer()
            
            Image(systemName: self.isOptionsPresented ? "chevron.up" : "chevron.down")
            // This modifier available for Image since iOS 16.0
                .fontWeight(.medium)
                .foregroundColor(.gray)
            
                .onTapGesture {
                    withAnimation {
                        isOptionsPresented.toggle()
                    }
                }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray,lineWidth: 2)
        }
        .overlay() {
            VStack {
                if isOptionsPresented, let options = options {
                    DropdownMenuList(
                        options: options,
                        sharedData: sharedData,
                        isOptionsPresented: $isOptionsPresented,
                        optionSelected: $optionSelected
                    )
                    //push dropdown under textfield
                    .offset(y: 120)
                }
            }
        }
    }
}

struct DropdownMenu_Previews: PreviewProvider {
    static var previews: some View {
        DropdownMenu(
            dropDownLabel: "Company *",
            sharedData: AddInterviewModel()) { query in
                
            }
    }
}
