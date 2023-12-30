//
//  FutureRounds.swift
//  job hunter
//
//  Created by Qingyuan Ma on 11/11/23.
//

import SwiftUI

struct FutureRounds: View {
    @ObservedObject var roundModel: InterviewRoundsModel
    @State private var showExpanded: Bool = true
    
    var availableRounds: [RoundModel] {
        let usedNames = Set(roundModel.pastRounds.map { $0.name })
        let availableOnes = AllRounds.filter { !usedNames.contains($0) }
        return availableOnes.map { RoundModel(name: $0) }
    }
        
    var body: some View {
        Section("Future Rounds") {
            HStack(alignment: .center) {
                Text("Future Rounds")
                    .font(.headline)
                Spacer()
                // Show the sheet
                Button {
                    withAnimation {
                        showExpanded.toggle()
                    }
                } label: {
                    Image(
                        systemName: showExpanded ?
                        "arrow.turn.right.up"
                        :"arrow.turn.left.down"
                    )
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
            } // Header ends
            .padding(.top, 5)
            .contentShape(Rectangle()) // Makes the entire HStack tappable
            .onTapGesture {
                withAnimation(.spring) { // Add animation here
                    showExpanded.toggle()
                }
            }
            
            if showExpanded {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(availableRounds, id: \.self.name) { round in
                        FutureRoundRow(round: round, roundModel: roundModel)
                    }
                }
                .transition(.slide)
                .id("futureRoundsEnd")
            }
            
        } // Section ends
        .animation(.easeInOut, value: showExpanded)
    }
}

struct FutureRoundRow: View {
    
    var round: RoundModel
    @ObservedObject var roundModel: InterviewRoundsModel
    @State private var isChecked: Bool = false
    @State private var roundStartDate: Date = Date()
    @State private var roundEndDate: Date = Date()
    
    private func updateStateFromModel() {
         if let existingRound = roundModel.futureRounds.first(where: { $0.name == round.name }) {
             isChecked = true
             roundStartDate = existingRound.startDate
             roundEndDate = existingRound.endDate
         }
     }
    
    /// If check the box, add the round. Otherwise remove it from futureRounds
    private func updateFutureRounds () {
        // Current is checked, then action: uncheck
        if (isChecked) {
            roundModel.futureRounds.removeAll {
                data in
                data.name == round.name
            }
            
        } else {
            // Current is un checked, then action: check
            roundModel.futureRounds.append(
                RoundModel(
                    name: round.name,
                    startDate: roundStartDate,
                    endDate: roundEndDate
                )
            )
        }
        isChecked.toggle()
    }
    
    private func updateSelectedRoundDate(round: RoundModel, newDate: Date, field: String) {
        let index = roundModel.futureRounds.firstIndex { futureRound in
            futureRound.name == round.name
        }
        
        if let index = index {
            switch field {
                case "startDate":
                    roundModel.futureRounds[index].startDate = newDate
                case "endDate":
                    roundModel.futureRounds[index].endDate = newDate
                default:
                    return
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                // Checkbox button
                Button {
                    withAnimation {
                        updateFutureRounds()
                    }
                } label: {
                    Image(
                        systemName:  isChecked ? "checkmark.square" : "square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                }
                
                .buttonStyle(.borderless)
                
                Text(round.name)
            } // Hstack ends
            
            if isChecked {
                VStack {
                    DatePicker(selection: $roundStartDate) {
                        LabeledContent {
                            Text("Start: ")
                        } label: {
                            Image(systemName: "calendar.badge.clock")
                        }
                    }
                    .onChange(of: roundStartDate) { _, newValue in
                        updateSelectedRoundDate(round: round, newDate: newValue, field: "startDate")
                    }
                    
                    DatePicker(selection: $roundEndDate) {
                        LabeledContent {
                            Text("End: ")
                        } label: {
                            Image(systemName: "calendar.badge.clock")
                        }
                    }
                    .onChange(of: roundEndDate) { _, newValue in
                        updateSelectedRoundDate(round: round, newDate: newValue, field: "endDate")
                    }
                }
                .animation(.linear, value: isChecked)
            } // isChecked ends
        }
        .onAppear {
            updateStateFromModel()
        }
    }
}

#Preview {
    struct Wrapper: View {
        @State var availableRounds: [RoundModel] = []
        var body: some View {
            List {
                FutureRounds(
                    roundModel: InterviewRoundsModel()
                )
            }
        }
    }
    return Wrapper()
}
