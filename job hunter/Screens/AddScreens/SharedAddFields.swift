//
//  AddInterviewView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/1/23.
//

import SwiftUI

struct SharedAddFields: View {
    
    
    @Binding var companyName: String
    @Binding var jobTitle:  String
    @Binding var startDate: Date
    
    var body: some View {
        Section {
            VStack {
                LabeledContent("Company") {
                    TextField("company name", text: $companyName)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .border(.tertiary)
                }
                
                LabeledContent("Job title") {
                    TextField("ex: Software Engineer", text: $jobTitle)
                        .autocapitalization(.allCharacters)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .border(.tertiary)
                }
                
                DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
            }
        }
    }
}



struct SharedAddFields_Previews: PreviewProvider {
    @State static private var companyName: String = "Sample Text"
    @State static private var jobTitle: String = "Sample Text"
    @State static private var startDate: Date = Date()
    static var previews: some View {
        SharedAddFields(companyName: $companyName, jobTitle: $jobTitle, startDate: $startDate)
    }
}
