//
//  AddPendingScreen.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/5/23.
//

import SwiftUI



struct AddPendingScreen: View {
    @StateObject var sharedData: InterviewSharedData = InterviewSharedData()
    
    var body: some View {
        NavigationView {
            List {
               
                SharedAddFields(sharedData: sharedData)

                // MARK: Past rounds
                PastRounds(sharedData: sharedData)
                
                // MARK: Next round
                //TODO: EACH ROUND HAS A CHECKBOX. iF ITS CHECKED, THEN SHOW THE DATE PICKET AFTER
                

                FutureRounds(sharedData: sharedData)
                
            } //LIST ENDS
            .listStyle(SidebarListStyle())
            .navigationBarTitle("Pending Interview", displayMode: .inline)
            .navigationBarItems(
                leading:Button("Cancel") {
                    print("close sheet!")
                },
                trailing: Button("Add") {
                    print("add the item!")
                }
            )
        } //NavigationView ends
        .edgesIgnoringSafeArea(.top)
    }
}

struct DebugView: View {
    let message: String

    init(_ message: String) {
        self.message = message
        print("DebugView initialized with message: \(message)")
    }

    var body: some View {
        EmptyView()
    }
}

struct PastRounds: View {
    @ObservedObject var sharedData: InterviewSharedData
    
    @State private var index = 0
    
    var body: some View {
        DebugView("PastRounds redraw!!!!")
        Section("PAST ROUNDS") {
            HStack(alignment: .bottom) {
                Text("Past Rounds")
                    .font(.headline)
                
                Spacer()
                
                // When click
                Button {
                    if (index < sharedData.allRounds.count) {
                        let round = RoundData()
                        
                        round.roundName = sharedData.allRounds[index]
                        sharedData.pastRounds.rounds.append(round)
                        index += 1
                        
                    }
                } label: {
                    Image(systemName: "rectangle.badge.plus")
                        .frame(width: 20, height: 20)
                        .contentShape(Rectangle())
                }
                // Fix the button tappable area too large takes whole row and column area
                .buttonStyle(BorderlessButtonStyle())

            } // Header ends
            .padding(.top, 5)
            
            ForEach(Array(sharedData.pastRounds.rounds), id: \.id) {
                round in
                DynamicRow(rowData: round, sharedData: sharedData)
            }
        }// Section ends
    }
}

struct FutureRounds: View {
    
    @ObservedObject var sharedData: InterviewSharedData
    @State private var checkedStates: [String: Bool] = [:]
   
    var availableRounds: [String] {
        let existingRoundNames = sharedData.pastRounds.rounds.map { $0.roundName }
        
        return sharedData.futureRounds.rounds.filter { !existingRoundNames.contains($0) && !$0.isEmpty }
    }
    
    var body: some View {
        Section("Future Rounds") {
            ForEach(availableRounds, id: \.self) { roundName in
                HStack {
                    CheckboxView(isChecked: $checkedStates[roundName])
                    Text(roundName)
                    if checkedStates[roundName] == true {
                        // Show DatePicker here
//                        DatePicker("", selection: $rowData.roundTime, displayedComponents: [.date])
                    }
                }
            }
        }
        .onAppear {
            print(Date())
        }
    }
}

struct CheckboxView: View {
    
    @Binding var isChecked: Bool?
    var body: some View {
        HStack {
            Button {
                if (isChecked == nil) {
                    isChecked = false
                }
                isChecked?.toggle()
            } label: {
                Image(systemName:  isChecked == true ? "checkmark.square" : "square")
            }
        }
    }
}

//struct ContentView: View {
//    @State private var isChecked = false
//
//    var body: some View {
//        CheckboxView(isChecked: $isChecked)
//    }
//}


struct AddPendingScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddPendingScreen()
    }
}
