//
//  PostionDetailSection.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/11/23.
//

import SwiftUI

struct PostionDetailSection: View {
    
    @EnvironmentObject var addInterviewModel: AddInterviewModel
    @ObservedObject var salaryModel: SalarySectionModel
    
    var body: some View {
        Section("Position Metadata") {
            VStack(spacing: 20) {
                // location preference
                VStack(alignment: .leading) {
                    Text("Position Location")
                        .fontWeight(.bold)
                        
                    Picker("", selection: $addInterviewModel.locationPreference) {
                        ForEach(["onsite", "remote", "hybrid"], id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                // relocation
                VStack(alignment: .leading) {
                    Text("Relocation Required")
                        .fontWeight(.bold)
                    
                    Picker("", selection: $addInterviewModel.relocationRequired) {
                        ForEach(["YES", "NO"], id: \.self) { value in
                            Text(value)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // visa sponsor
                VisaSponsorSection()
                
                // salary info
                Toggle(
                    isOn: $addInterviewModel.addExpectedSalary.animation(.linear(duration: 0.5)
                    )
                ) {
                    Text("Add Expect Salary Info")
                        .fontWeight(.bold)
                }
                
                if addInterviewModel.addExpectedSalary {
                    SalarySection(salaryModel: salaryModel)
                }
            }
        }
    }
}

struct PostionDetailSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PostionDetailSection(
                salaryModel: SalarySectionModel()
            )
            .environmentObject(AddInterviewModel())
        }
    }
}
