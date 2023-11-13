//
//  PastRounds.swift
//  job hunter
//
//  Created by Qingyuan Ma on 11/11/23.
//

import SwiftUI
import FirebaseFirestore


class RoundModel: Encodable, ObservableObject, Equatable {
    var name: String
    @Published var date: Date
    @Published var notes: String
    @Published var lastingTime: Int
    
    init(
        name: String,
        date: Date = Date(),
        notes: String = "",
        lastingTime: Int = 60
    ) {
        self.name = name
        self.date = date
        self.notes = notes
        self.lastingTime = lastingTime
    }
    
    // Equatable Conformance
    static func == (lhs: RoundModel, rhs: RoundModel) -> Bool {
        return lhs.name == rhs.name &&
        lhs.date == rhs.date &&
        lhs.notes == rhs.notes &&
        lhs.lastingTime == rhs.lastingTime
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case date
        case notes
        case lastingTime = "lasting_time"
    }
    
    /**
     When call Firestore.Encoder on the instance:
     encode(to:) function implemented will be used, and it will take precedence over the default behavior defined by the Firestore.Encoder's keyEncodingStrategy.
     */
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(date, forKey: .date)
        try container.encode(notes, forKey: .notes)
        try container.encode(lastingTime, forKey: .lastingTime)
    }
}


class InterviewRoundsModel: ObservableObject {
    @Published var pastRounds: [RoundModel] = []
    @Published var futureRounds: [RoundModel] = []
    
    func addPastRound(name: String) {
        pastRounds.append(RoundModel(name: name))
    }
    
}

struct PastRounds: View {
    @ObservedObject var sharedData: AddInterviewModel
    @StateObject var roundModel = InterviewRoundsModel()
    
    @State private var expandSection: Bool = false
    
    func encodeRoundModels(roundModels: [RoundModel]) {
        let encoder = Firestore.Encoder()
        do {
            let encodedRounds = try roundModels.map { try encoder.encode($0) }
            print("encodedRounds are: \(encodedRounds)")
            // Now `encodedRounds` is an array of dictionaries with the encoded round data
        } catch {
            print(error)
        }

    }
    
    var body: some View {
        Button("Encode") {
            encodeRoundModels(roundModels: roundModel.pastRounds)
        }
        Section("PAST ROUNDS") {
            
            HStack(alignment: .center) {
                Text("Past Rounds")
                    .font(.headline)
                Spacer()
                // Toggel button
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
            
            //MARK: Added past rounds
            if (roundModel.pastRounds.count != 0) {
                VStack {
                    ForEach(roundModel.pastRounds.indices, id: \.self) { index in
                        HStack {
                            Button {
                                // Remove past round from model
                                let roundNameToRemove = roundModel.pastRounds[index].name
                                withAnimation {
                                    DispatchQueue.main.async {
                                        roundModel.pastRounds.removeAll { $0.name == roundNameToRemove }
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
                            
                            Text(roundModel.pastRounds[index].name)
                            DatePicker("", selection: $roundModel.pastRounds[index].date, displayedComponents: [.date])
                        } // HStack ends
                        .transition(.slide)
                    }
                } // VStack ends
                .animation(.easeInOut, value: roundModel.pastRounds)
            }
            
            
            //MARK: List of all
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
        }// Section ends
    }
}
#Preview {
    List {
        PastRounds(sharedData: AddInterviewModel())
    }
}
