//
//  PastRounds.swift
//  job hunter
//
//  Created by Qingyuan Ma on 11/11/23.
//

import SwiftUI

//TODO: isolate FutureRounds from AddInterviewModel to a new Observable object

class RoundVal: ObservableObject {
    let id = UUID() // Unique identifier for each round
    var name: String
    @Published var date: Date
    

    init(name: String, date: Date = Date()) {
        self.name = name
        self.date = date
    }
}

class InterviewRoundModel: ObservableObject {
    @Published var pastRounds: [RoundVal] = []
    @Published var futureRounds: [RoundVal] = []
    
    func addPastRound(name: String) {
        pastRounds.append(RoundVal(name: name))
    }
    
}

struct PastRounds: View {
    @ObservedObject var sharedData: AddInterviewModel
    @StateObject var roundModel = InterviewRoundModel()
    
    @State private var expandSection: Bool = false
    
    var body: some View {
        Section("PAST ROUNDS") {
            HStack(alignment: .center) {
                Text("Past Rounds")
                    .font(.headline)
                Spacer()
                Button {
                    expandSection.toggle()
                } label: {
                    Image(systemName: expandSection ? "arrow.down.square.fill": "arrow.up.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                        .foregroundColor(.gray)
                        
                }
                .buttonStyle(BorderlessButtonStyle())
            } // Header ends
            .padding(.top, 5)
            .contentShape(Rectangle()) // Makes the entire HStack tappable
            .onTapGesture {
                withAnimation(.spring) { // Add animation here
                    expandSection.toggle()
                }
            }
            
            // Display added past rounds
            if (roundModel.pastRounds.count != 0) {
                VStack {
                    ForEach(roundModel.pastRounds.indices, id: \.self) { index in
                        HStack {
                            Text(roundModel.pastRounds[index].name)
                            DatePicker("", selection: $roundModel.pastRounds[index].date, displayedComponents: [.date])
                        }
                    }
                }
            }
            
            
            
            if expandSection {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(AllRounds, id: \.self) { round in
                            Button{
                                // Add past round to roundModel
                                roundModel.addPastRound(name: round)
                            } label: {
                                HStack {
                                    Text(round)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "plus.app.fill")
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                            //roundModel.pastRounds.contains(where: { $0.name == round }) decide if the round added to pastRounds
                                .background(roundModel.pastRounds.contains(where: { $0.name == round }) ? Color.gray : Color.blue)
                                .clipShape(Capsule())
                            }
                            .disabled(roundModel.pastRounds.contains(where: { $0.name == round }))
                            .opacity(roundModel.pastRounds.contains(where: { $0.name == round }) ? 0.5 : 1)
                        }
                    }
                    .padding()
                }
                .transition(.move(edge: .bottom))
            }
        }// Section ends
    }
}
#Preview {
    List {
        PastRounds(sharedData: AddInterviewModel())
    }
}
