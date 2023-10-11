//
//  AddInterviewView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/1/23.
//

import SwiftUI

struct BasicFields: View {
    
    
//    @Binding var companyName: String
//    @Binding var jobTitle:  String
//    @Binding var startDate: Date
    @ObservedObject var sharedData: InterviewSharedData
    
    var body: some View {
        Section("Basic information") {
            VStack {
                LabeledContent("Company *") {
                    TextField("company name", text: $sharedData.companyName)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .border(.tertiary)
                }
                
                LabeledContent("Job title *") {
                    TextField("ex: Software Engineer", text: $sharedData.jobTitle)
                        .autocapitalization(.allCharacters)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .border(.tertiary)
                }
                
                DatePicker("Start Date *", selection: $sharedData.startDate, displayedComponents: [.date])
            }
        }
    }
}



struct BasicFields_Previews: PreviewProvider {
//    @State static private var companyName: String = "Sample Text"
//    @State static private var jobTitle: String = "Sample Text"
//    @State static private var startDate: Date = Date()
    static var previews: some View {
        BasicFields(sharedData: InterviewSharedData())
//        BasicFields(companyName: $companyName, jobTitle: $jobTitle, startDate: $startDate)
    }
}
