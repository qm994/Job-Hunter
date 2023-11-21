//
//  SalarySection.swift
//  job hunter
//
//  Created by Qingyuan Ma on 11/19/23.
//

import SwiftUI

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
#Preview {
    struct Wrapper: View {
        @StateObject var salaryModel = SalarySectionModel()
        var body: some View {
            SalarySection(salaryModel: salaryModel)
        }
    }
   
    return Wrapper()
}
