//
//  FutureRounds.swift
//  job hunter
//
//  Created by Qingyuan Ma on 11/11/23.
//

import SwiftUI

//TODO: isolate FutureRounds from AddInterviewModel to a new Observable object


struct FutureRounds: View {
    
    @ObservedObject var sharedData: AddInterviewModel
    @State private var checkedStates: [String: Bool] = [:]
   
    var futureRounds: [ExtendedRoundData] {
        return sharedData.futureRounds.rounds.map { roundName in
            let round = ExtendedRoundData()
            round.roundName = roundName
            return round
        }
    }

    var body: some View {
        Section("Future Rounds") {
            ForEach(futureRounds, id: \.id) { round in
                HStack(alignment: .center) {
                    CheckboxView(roundName: round.roundName, isChecked: $checkedStates[round.roundName])
                    DynamicRow(rowData: round, sharedData: sharedData)
                }
                .frame(height:40)
               
            }
        }
        .onAppear {
            print(Date())
        }
    }
}

#Preview {
    List {
        FutureRounds(
            sharedData: AddInterviewModel()
        )
    }
}
