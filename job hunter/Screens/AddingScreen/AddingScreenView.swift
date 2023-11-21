//
//  AddingScreenView.swift
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
struct AddingScreenView: View {
    @StateObject var addInterviewModel: AddInterviewModel = AddInterviewModel()
    
    @StateObject var salaryModel: SalarySectionModel = SalarySectionModel()
    
    @StateObject var roundModel = InterviewRoundsModel()

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
                    AddInterviewButton(
                        salaryModel: salaryModel,
                        roundModel: roundModel,
                        path: $path
                    )
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

struct AddingScreenView_Previews: PreviewProvider {
    @State static var path: [String] = []
    static var previews: some View {
        
        AddingScreenView(path: $path)
            .environmentObject(AuthenticationModel())
        
    }
}
