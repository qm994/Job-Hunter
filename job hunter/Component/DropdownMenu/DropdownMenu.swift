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
    let icon: String?
    
    init(name: String, icon: String? = nil) {
        self.name = name
        self.icon = icon
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
   
    @ObservedObject var sharedData: InterviewSharedData
    
    
    @State private var isOptionsPresented: Bool = false
    @State private var selectedOption: DropdownMenuCompanyOption? = nil
    /// this is called when bind value with TextField change and it act as the loader of autocomplete
    var onLoadDataWhenChange: (_ query: String) -> Void
    
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            HStack {
                Spacer()
                Text(dropDownLabel)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Rectangle()
                    .frame(width: 1, height: 20, alignment: .center)  // Creates a thin vertical line
                    .foregroundColor(.gray)
                Spacer()
            }
            .frame(width: screenWidth * 0.35)
         
            
            
            TextField(selectedOption == nil ? "Select company" : selectedOption!.name, text: $sharedData.companyName)
                .autocapitalization(.none)
                .fontWeight(.medium)
                .foregroundColor(selectedOption == nil ? .gray : .black)
                .frame(maxWidth: .infinity)
                .onChange(of: sharedData.companyName, initial: false) { _, newValue in
                    
                        onLoadDataWhenChange(newValue)
                        isOptionsPresented = true
                }
                
            
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
                    //Spacer(minLength: 60)
                    DropdownMenuList(options: options) { option in
                        self.isOptionsPresented = false
                        self.selectedOption = option
                    }
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
            sharedData: InterviewSharedData()) { query in
                
            }
    }
}
