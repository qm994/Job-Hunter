//
//  AddInterviewView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/1/23.
//

import SwiftUI



struct BasicFields: View {
    
    @ObservedObject var sharedData: InterviewSharedData
    
    @StateObject var model = ClearbitViewModel()
    
    let debouncer = Debouncer(delay: 1)
    
    var body: some View {
        VStack {
            
            DropdownMenu(
                options: model.companyList,
                dropDownLabel: "Company *",
                sharedData: sharedData
            ) { value in
                debouncer.debounce {
                    Task {
                        await model.fetchCompaniesData(startwith: value)
                    }
                }
            }
            .zIndex(1)  // This will ensure the DropdownMenu appears on top of other views
            
            
            CustomizedTextField(label: "Job Title*", fieldPlaceHolder: "ex: Senior Software Enginer", fieldValue: $sharedData.jobTitle)
            
            DatePicker("Start Date *", selection: $sharedData.startDate, displayedComponents: [.date])
        }
    }
}



struct BasicFields_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            BasicFields(sharedData: InterviewSharedData())
        }
    }
}


