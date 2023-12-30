//
//  AddingScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/5/23.
//

import SwiftUI

class SalarySectionModel: ObservableObject {
    @Published var base: Double
    @Published var equity: Double
    @Published var signon: Double
    @Published var bonus: Double
    
    init(base: Double = 0, equity: Double = 0, signon: Double = 0, bonus: Double = 0) {
        self.base = base
        self.equity = equity
        self.signon = signon
        self.bonus = bonus
    }
}

// Define a struct to hold the salary information
struct SalaryInfo {
    var base: Double
    var bonus: Double
    var equity: Double
    var signon: Double
    
    // Initialize with default values
    init(base: Double = 0, bonus: Double = 0, equity: Double = 0, signon: Double = 0) {
        self.base = base
        self.bonus = bonus
        self.equity = equity
        self.signon = signon
    }
}


//TODO: Prevent users add if required fields are missing ex: mark the fields with red border and exclamation mark
struct AddingScreenView: View {
    @StateObject var addInterviewModel: AddInterviewModel = AddInterviewModel()
    
    @StateObject var salaryModel: SalarySectionModel = SalarySectionModel()
    
    @StateObject var roundModel = InterviewRoundsModel()

    @EnvironmentObject var authModel: AuthenticationModel
    @EnvironmentObject var coreModel: CoreModel
    
    @State private var isFutureEnabled: Bool = false
    
   
    
    @Binding var existingInterview:  FetchedInterviewModel?
    
    var body: some View {
        // MARK: ScrollViewReader Auto Scroll
        DebugView("addInterviewModel.existingInterviewId is \(addInterviewModel.existingInterviewId)")
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
                        addInterviewModel.existingInterviewId = nil
                        coreModel.editInterview = nil
                        if let screenName = coreModel.path.firstIndex(of: NavigationPath.addInterviewScreen.rawValue) {
                            coreModel.path.remove(at: screenName)
                        }
                    },
                trailing:
                    Group {
                        if let existingInterview = existingInterview {
                            AddInterviewButton(
                                salaryModel: salaryModel,
                                roundModel: roundModel,
                                isUpdate: true
                            )
                        } else {
                            AddInterviewButton(
                                salaryModel: salaryModel,
                                roundModel: roundModel
                            )
                        }
                    }
            )
            .navigationBarBackButtonHidden(true)
        } // ScrollView Ends
        .environmentObject(addInterviewModel)
        .onAppear {
            if let interview = existingInterview {
                addInterviewModel.existingInterviewId = interview.id
                // Populate your models with existing data
                addInterviewModel.addExpectedSalary = true
                salaryModel.base = interview.salary.base
                salaryModel.equity = interview.salary.equity
                salaryModel.signon = interview.salary.signon
                salaryModel.bonus = interview.salary.bonus
                
                addInterviewModel.company = Company(name: interview.company)
                addInterviewModel.jobTitle = interview.jobTitle
                addInterviewModel.startDate = interview.startDate
                if let status = ApplicationStatus(rawValue: interview.status) {
                    addInterviewModel.status = status
                }
                
                addInterviewModel.locationPreference = interview.locationPreference
                if interview.relocationRequired {
                    addInterviewModel.relocationRequired = "YES"
                } else {
                    addInterviewModel.relocationRequired = "NO"
                }
                
                if let visaRequired = interview.visaRequired {
                    addInterviewModel.needVisaSponsor = true
                    addInterviewModel.requiredVisa = visaRequired
                }
                
                // TODO: Prefill rounds data
                print("interview.pastRounds: \(interview.pastRounds)")
                
                roundModel.pastRounds = interview.pastRounds
                if interview.futureRounds.count > 0 {
                    self.isFutureEnabled = true
                    roundModel.futureRounds = interview.futureRounds
                }
                
                
            }
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

struct AddingScreenView_Previews: PreviewProvider {
    @State static var existingInterview: FetchedInterviewModel? = nil
    static var previews: some View {
        
        AddingScreenView(existingInterview: $existingInterview)
            .environmentObject(AuthenticationModel())
            .environmentObject(CoreModel())
        
    }
}
