//
//  DynamicRow.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/7/23.
//

import SwiftUI

struct DynamicRow: View {
    @ObservedObject var rowData: RoundData
    @ObservedObject var sharedData: AddInterviewModel
    
    var body: some View {
        HStack {
            DatePicker("", selection: $rowData.roundTime, displayedComponents: [.date])
            Spacer()
            Picker("", selection: $rowData.roundName) {
                ForEach(AllRounds, id: \.self) {
                    Text($0).tag($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: rowData.roundName) { newValue in
                // Change a pastround name will update futureRounds
                if let index = sharedData.pastRounds.rounds.firstIndex(where: {$0.id == rowData.id}) {
                    sharedData.pastRounds.rounds[index].roundName = newValue
                }
            }
        }
    }
}

