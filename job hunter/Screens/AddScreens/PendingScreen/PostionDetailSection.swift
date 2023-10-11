//
//  PostionDetailSection.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/11/23.
//

import SwiftUI

struct PostionDetailSection: View {
//    @Binding var locationPreference: String
//    @Binding var relocationRequired: String
//    @Binding var addExpectedSalary: Bool
    @ObservedObject var sharedData: InterviewSharedData
    
    var body: some View {
        Section("Position Metadata") {
            DebugView("PostionDetailSection redraw")
            VStack(spacing: 20) {
                // location preference
                VStack(alignment: .leading) {
                    Text("Location Preference *")
                        .font(.subheadline)
                    Picker("Location Preference", selection: $sharedData.locationPreference) {
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
                    Picker("Location Preference", selection: $sharedData.relocationRequired) {
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
                    SalarySection(sharedData: sharedData)
                }
            }
        }
    }
}

struct SalarySection: View {
    @ObservedObject var sharedData: InterviewSharedData
    var body: some View {
        DebugView("sharedData.equity value: \(sharedData.equity)")
        NumericInput(label: "Base pay / Year", titleKey: "annually base pay", input: $sharedData.base)
        NumericInput(label: "Equity / 4 Yrs", titleKey: "4 years stocks/options", input: $sharedData.equity)
        NumericInput(label: "Signon Bonus", titleKey: "total signon cash", input: $sharedData.signon)
        NumericInput(label: "Yearly Bonus", titleKey: "expect % of bonus", input: $sharedData.bonus)
    }
}

struct PostionDetailSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PostionDetailSection(
                sharedData: InterviewSharedData()
            )
        }
    }
}
