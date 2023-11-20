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


//TODO: Prevent users add if required fields are missing ex: mark the fields with red border and exclamation mark
struct AddPendingScreen: View {
    @StateObject var addInterviewModel: AddInterviewModel = AddInterviewModel()
    
    @StateObject var salaryModel: SalarySectionModel = SalarySectionModel()
    
    @StateObject var roundModel = InterviewRoundsModel()
    
    @EnvironmentObject var routerManager: AddScreenViewRouterManager
    @EnvironmentObject var authModel: AuthenticationModel
    
    @State private var isFutureEnabled: Bool = false
    
    @Binding var path: [String]
    
    var body: some View {
        // MARK: ScrollViewReader Auto Scroll
        ScrollViewReader { scrollView in
            List {
                BasicFields()
                
                PostionDetailSection(
                    salaryModel: salaryModel
                )
                
                // MARK: Past rounds
                PastRounds(roundModel: roundModel)
                
                // MARK: Next round
                
                Toggle("Add Future Interview", isOn: $isFutureEnabled)
                
                if isFutureEnabled {
                    Text("No Duplicates Allowed Between Past and Future Rounds")
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                    FutureRounds(
                        roundModel: roundModel
                    )
                }
                
            } //LIST ENDS
            .onChange(of: isFutureEnabled, initial: false) { _, newValue in
                print("new value is : \(newValue)")
                if newValue {
                    withAnimation {
                        scrollView.scrollTo("futureRoundsEnd", anchor: .bottomLeading)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .navigationBarTitle("Add \(addInterviewModel.status.rawValue) Interview", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        print("cancel called")
                        
                        if let screenName = path.firstIndex(of: NavigationPath.addInterviewScreen.rawValue) {
                            path.remove(at: screenName)
                        }
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
                                    base:  addInterviewModel.addExpectedSalary ? salaryModel.base : 0,
                                    bonus: addInterviewModel.addExpectedSalary ? salaryModel.bonus : 0,
                                    equity: addInterviewModel.addExpectedSalary ? salaryModel.equity: 0,
                                    signon: addInterviewModel.addExpectedSalary ? salaryModel.signon : 0
                                )
                                
                                //Add interview and its sub collections
                                
                                try await addInterviewModel.addInterviewToFirestore(
                                    user: userProfile,
                                    salary: salaryInfo,
                                    pastRounds: roundModel.pastRounds,
                                    futureRounds: roundModel.futureRounds
                                )
                                
                                // Move back to main screen
                                path.removeAll { pathName in
                                    pathName == NavigationPath.addInterviewScreen.rawValue
                                }
                                print("Interview added successfully")
                            } catch {
                                // Handle the error appropriately
                                print("Error adding interview: \(error)")
                            }
                        }
                    }
            )
            .navigationBarBackButtonHidden(true)
        } // ScrollView Ends
        .environmentObject(addInterviewModel)
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
    @State static var path: [String] = []
    static var previews: some View {
        
        AddPendingScreen(path: $path)
            .environmentObject(AddScreenViewRouterManager())
            .environmentObject(AuthenticationModel())
        
    }
}
