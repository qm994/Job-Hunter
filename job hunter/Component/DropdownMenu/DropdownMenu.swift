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
    
    var body: some View {
        DebugView("is the isOptionsPresented: \(isOptionsPresented)")
        DebugView("options are: \(options)")
        Button {
            withAnimation {
                isOptionsPresented.toggle()
            }
        } label: {
            HStack {
                Text(dropDownLabel)
                    .fontWeight(.bold)
                    
                Rectangle()
                        .frame(width: 1, height: 20, alignment: .center)  // Creates a thin vertical line
                        .foregroundColor(.gray)
                
                TextField(selectedOption == nil ? "Select company" : selectedOption!.name, text: $sharedData.companyName)
                    .fontWeight(.medium)
                    .foregroundColor(selectedOption == nil ? .gray : .black)
                    .frame(maxWidth: .infinity)
                    .onChange(of: sharedData.companyName) { newValue in
                        onLoadDataWhenChange(newValue)
                        isOptionsPresented = true
                    }
                    
                
                Spacer()
                
                Image(systemName: self.isOptionsPresented ? "chevron.up" : "chevron.down")
                // This modifier available for Image since iOS 16.0
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            
        } //Button ends
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray,lineWidth: 2)
        }
        .overlay() {
            VStack {
                if isOptionsPresented && options != nil {
                    //Spacer(minLength: 60)
                    DropdownMenuList(options: options!) { option in
                        self.isOptionsPresented = false
                        self.selectedOption = option
                    }
                    .offset(y: 120)
                }
            }
        }
        // We need to push views under drop down menu down, when options list is
        // open
//        .padding(
//            // Check if options list is open or not
//            .bottom, self.isOptionsPresented && options != nil
//            // If options list is open, then check if options size is greater
//            // than 300 (MAX HEIGHT - CONSTANT), or not
//            ? CGFloat(options!.count * 32) > 300
//            // IF true, then set padding to max height 300 points
//            ? 300 + 30 // max height + more padding to set space between borders and text
//            // IF false, then calculate options size and set padding
//            : CGFloat(options!.count * 32) + 30
//            // If option list is closed, then don't set any padding.
//            : 0
//        )
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
