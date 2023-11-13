//
//  AddPendingScreen.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/5/23.
//

import SwiftUI

class SalarySectionModel: ObservableObject {
    @Published var base: Double = .zero
    @Published var equity: Double = .zero
    @Published var signon: Double = .zero
    @Published var bonus: Double = .zero // percent?
}

// Define a struct to hold the salary information
struct SalaryInfo {
    var base: Double
    var bonus: Double
    var equity: Double
    var signon: Double
}

struct AddPendingScreen: View {
    @StateObject var sharedData: AddInterviewModel = AddInterviewModel()
    
    @StateObject var salaryModel: SalarySectionModel = SalarySectionModel()
    
    @StateObject var roundModel = InterviewRoundsModel()
    
    @EnvironmentObject var routerManager: AddScreenViewRouterManager
    @EnvironmentObject var authModel: AuthenticationModel
    
    @State private var isFutureEnabled: Bool = false

    
    var body: some View {        
        NavigationStack {
            List {
                BasicFields(sharedData: sharedData)
                
                PostionDetailSection(
                    sharedData: sharedData,
                    salaryModel: salaryModel
                )
                
                // MARK: Past rounds
                PastRounds(roundModel: roundModel)
                
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
                trailing:
                    Button("Add") {
                        Task {
                            do {
                                guard let userProfile = authModel.userProfile else {
                                    print("User profile is not available")
                                    return
                                }
                                
                                // Extract salary info if enabled
                                let salaryInfo = SalaryInfo(
                                    base:  sharedData.addExpectedSalary ? salaryModel.base : 0,
                                    bonus: sharedData.addExpectedSalary ? salaryModel.bonus : 0,
                                    equity: sharedData.addExpectedSalary ? salaryModel.equity: 0,
                                    signon: sharedData.addExpectedSalary ? salaryModel.signon : 0
                                )
                                        
                                //Add interview and its sub collections
                                try await sharedData.addInterviewToFirestore(
                                        user: userProfile,
                                        salary: salaryInfo,
                                        pastRounds: roundModel.pastRounds
                                )
                                routerManager.isSheetPresented = false
                                print("Interview added successfully")
                            } catch {
                                // Handle the error appropriately
                                print("Error adding interview: \(error)")
                            }
                        }
                    }
            )
        } //NavigationView ends
        .edgesIgnoringSafeArea(.top)
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
        AddPendingScreen()
            .environmentObject(AddScreenViewRouterManager())
            .environmentObject(AuthenticationModel())
    }
}
