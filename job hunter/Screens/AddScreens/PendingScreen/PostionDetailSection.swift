//
//  PostionDetailSection.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/11/23.
//

import SwiftUI

struct PostionDetailSection: View {
    
    @ObservedObject var sharedData: AddInterviewModel
    @ObservedObject var salaryModel: SalarySectionModel
    
    var body: some View {
        Section("Position Metadata") {
            VStack(spacing: 20) {
                // location preference
                VStack(alignment: .leading) {
                    Text("Position Location *")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Picker("", selection: $sharedData.locationPreference) {
                        ForEach(["onsite", "remote", "hybrid"], id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                // relocation
                VStack(alignment: .leading) {
                    Text("Is Relocation Required *")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Picker("", selection: $sharedData.relocationRequired) {
                        ForEach(["YES", "NO"], id: \.self) { value in
                            Text(value)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Toggle(isOn: $sharedData.addExpectedSalary.animation(.linear(duration: 0.5))) {
                    Text("Add Expect Salary Info")
                        .font(.subheadline)
                }
                
                if sharedData.addExpectedSalary {
                    SalarySection(salaryModel: salaryModel)
                }
            }
        }
    }
}


struct SalarySection: View {
    @ObservedObject var salaryModel: SalarySectionModel
    var body: some View {
        NumericInput(label: "Base pay / Year", titleKey: "annually base pay", input: $salaryModel.base)
        NumericInput(label: "Equity / 4 Yrs", titleKey: "4 years stocks/options", input: $salaryModel.equity)
        NumericInput(label: "Signon Bonus", titleKey: "total signon cash", input: $salaryModel.signon)
        
        VStack(alignment: .leading) {
            
            Label(
                title: { Text("Yearly Bonus") },
                icon: { Image(systemName: "dollarsign.circle") }
            )
            
            HStack {
                Text("\(Int(salaryModel.bonus * 100))%")
                    .font(.caption)
                    .frame(width: 100, height: 20, alignment: .center)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(5)
                Slider(
                    value: $salaryModel.bonus,
                    in: 0...1,
                    step: 0.01,
                    minimumValueLabel: Text("0%"),
                    maximumValueLabel: Text("100%"),
                    label: {
                        Text("Percentage")
                    }
                )
            }
        }
    }
}

struct PostionDetailSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PostionDetailSection(
                sharedData: AddInterviewModel(),
                salaryModel: SalarySectionModel()
            )
        }
    }
}
