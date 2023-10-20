//
//  AddPendingScreen.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/5/23.
//

import SwiftUI



struct AddPendingScreen: View {
    @StateObject var sharedData: InterviewSharedData = InterviewSharedData()
    @EnvironmentObject var routerManager: AddScreenViewRouterManager
    
    @State private var isFutureEnabled: Bool = false

    
    var body: some View {        
        NavigationStack {
            List {
                BasicFields(sharedData: sharedData)
                PostionDetailSection(sharedData: sharedData)
                
                // MARK: Past rounds
                PastRounds(sharedData: sharedData)
                
                // MARK: Next round
            
                Toggle("Add Future Interview", isOn: $isFutureEnabled)
                
                if isFutureEnabled {
                    Text("No Duplicates Allowed Between Past and Future Rounds")
                        .font(.footnote)
                        .frame(width: .infinity)
                        .multilineTextAlignment(.leading)
                    FutureRounds(sharedData: sharedData)
                }

            } //LIST ENDS
            .listStyle(SidebarListStyle())
            .navigationBarTitle("Pending Interview", displayMode: .inline)
            .navigationBarItems(
                leading:Button("Cancel") {
                    routerManager.isSheetPresented = false
                },
                trailing: Button("Add") {
                    //TODO: Get sharedData's values and send to server once add
                    print("add the item!")
                }
            )
        } //NavigationView ends
        .edgesIgnoringSafeArea(.top)
    }
}

struct PastRounds: View {
    @ObservedObject var sharedData: InterviewSharedData
    
    @State private var index = 0
    
    var body: some View {
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

struct CheckboxView: View {
    
    var roundName: String
    
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


struct AddPendingScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddPendingScreen().environmentObject(AddScreenViewRouterManager())
    }
}
