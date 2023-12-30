//
//  PastRounds.swift
//  job hunter
//
//  Created by Qingyuan Ma on 11/11/23.
//

import SwiftUI
import FirebaseFirestore

let AllRounds = [
    "Online Assessment", "HR Call", "Peer Interview", "HM Call",
    "Case Study/Presentation", "Final/Onsite Round", "References Check", "HR Offer Call", "Final Offer",
    "Accept Offer"
]

class InterviewRoundsModel: ObservableObject {
    @Published var pastRounds: [RoundModel] = []
    @Published var futureRounds: [RoundModel] = []
    
    var availableRounds: [RoundModel] {
        let usedNames = Set(pastRounds.map { $0.name } + futureRounds.map { $0.name })
        let availableOnes = AllRounds.filter { !usedNames.contains($0) }
        return availableOnes.map { RoundModel(name: $0) }
    }
    
    func addPastRound(name: String) {
        if !pastRounds.contains(where: { $0.name == name }) {
            pastRounds.append(RoundModel(name: name))
        }
    }
    
    func addFutureRound(name: String) {
        if !futureRounds.contains(where: { $0.name == name }) {
            futureRounds.append(RoundModel(name: name))
        }
    }
}

struct PastRounds: View {
    @ObservedObject var roundModel: InterviewRoundsModel
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        Section("PAST ROUNDS") {
            
            HStack(alignment: .center) {
                Text("Past Rounds")
                    .font(.headline)
                Spacer()
                // Show the sheet
                Button {
                   showSheet = true
                } label: {
                    Image(
                        systemName: showSheet ?
                        "arrow.down.right.and.arrow.up.left"
                        :"arrow.up.left.and.arrow.down.right"
                    )
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
            } // HStack ends
            .padding(.top, 5)
            .contentShape(Rectangle()) // Makes the entire HStack tappable
            .onTapGesture {
                withAnimation(.spring) { // Add animation here
                    showSheet.toggle()
                }
            }
            
            //MARK: Added past rounds

            SelectedRoundsView(rounds: $roundModel.pastRounds)
            
        }// Section ends
        .sheet(isPresented: $showSheet) {
            PastRoundsList(roundModel: roundModel)
                .presentationDetents([.medium, .large])
                .presentationBackground(.thinMaterial)
                .presentationDragIndicator(.visible)
                .presentationContentInteraction(.scrolls)
                .presentationCornerRadius(50)
        }
       
        
    }
}

struct SelectedRoundsView: View {
    @Binding var rounds: [RoundModel]
    var body: some View {
        if !rounds.isEmpty {
            VStack {
                
                ForEach(rounds.indices, id: \.self) { index in
                    HStack {
                        Button {
                            // Remove past round from model
                            let roundNameToRemove = rounds[index].name
                            withAnimation {
                                DispatchQueue.main.async {
                                    rounds.removeAll { $0.name == roundNameToRemove }
                                }
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(UIColor.systemRed))
                        }
                        .contentShape(Circle())
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Text(rounds[index].name)
                        DatePicker("", selection: $rounds[index].startDate, displayedComponents: [.date])
                    } // HStack ends
                    .transition(.slide)
                } // ForEach ends
            } // VStack ends
            .animation(.easeInOut, value: rounds)
        }
    }
}

// TODO: Make this view as reusbale to visa view can reuse it
struct PastRoundsList: View {
    @ObservedObject var roundModel: InterviewRoundsModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {

                ForEach(AllRounds, id: \.self) { round in
                    Button{
                        // Add past round to roundModel
                        roundModel.addPastRound(name: round)
                    } label: {
                        HStack {
                            Text(round)
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "plus.app.fill")
                        }
                        .foregroundStyle(.black)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                    //roundModel.pastRounds.contains(where: { $0.name == round }) decide if the round added to pastRounds
                        .background(roundModel.pastRounds.contains(where: { $0.name == round }) ? Color.gray : Color(UIColor.systemGreen))
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
}


#Preview {
    struct Wrapper: View {
        
        var body: some View {
            List {
                PastRounds(
                    roundModel: InterviewRoundsModel()
                    
                )
            }
        }
    }
    return Wrapper()
}
