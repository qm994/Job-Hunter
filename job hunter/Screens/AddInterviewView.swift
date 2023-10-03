//
//  AddInterviewView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/1/23.
//

import SwiftUI

// TODO: WE SHOULD STORE EACH INTERVIEW'S ALL PAST ROUNDS NAME AND ITS RESULT SO WE CAN SHOW A PROGRESS BAR FOR CUSTOMERS

struct AddInterviewView: View {
    @State private var companyName = ""
    @State private var jobCategory = "Engineer"
    @State private var jobTitle = "Junior"
    @State private var startDate: Date = Date()
    @State private var selectedRound = "HR Call"
    // If has next round,show the nextRound dropdown
    // otherwise, let customer choose whether is pending or rejected
    @State private var hasNextRound: Bool = true
    @State private var status: String = "Pending" // For Pending or Rejected
     @State private var rejectionReason: String = "" // For the text area
    
    let types = ["Engineer", "Designer", "Product Manager"]
    let titles = [
        "Junior", "Mid-level", "Senior", "Staff/Principal"
    ]
    let rounds = ["Online Assessment", "HR Call", "Init Technical Round", "HM Call", "Final Round", "HR Offer Call", "Final Offer", "Accept Offer"]
    
    
    
    var body: some View {
        VStack {
                Form {
                    LabeledContent("Company") {
                        TextField("company name", text: $companyName)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Picker("Job types", selection: $jobCategory) {
                        ForEach(types, id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Picker("Title", selection: $jobTitle) {
                        ForEach(titles, id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                    
                    Picker("Interview Round", selection: $selectedRound) {
                        ForEach(rounds, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    //TODO: Put next rounds related in a diff section
                    //TODO: Ask if user would like to choose choose how many rounds for the interview and create a way of visualize the rounds in timeline format
                           
                    // Toggle for next round
                    Toggle("Has Next Round?", isOn: $hasNextRound)

                    
                    /*
                     If has next round:
                        Display the next round date
                     Otherwise:
                        if its rejected, show the feedback area
                     */
                    
                    if hasNextRound {
                        DatePicker("Next round date", selection: $startDate, displayedComponents: [.date])
                                            
                    } else {
                        Picker("Status", selection: $status) {
                            Text("Pending").tag("Pending")
                            Text("Rejected").tag("Rejected")
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        if status == "Rejected" {
                            TextEditor(text: $rejectionReason)
                                .frame(height: 100)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }
                    } //else ends
                    
                    //TODO: MAKE BUTTON REUSABLE
                    //MARK: BUTTON
                    Section {
                        VStack {
                            HStack {
                                Spacer()
                                Button{
                                    print("Confirm Add")
                                    
                                } label: {
                                    Text("Confirm Add")
                                }
                                Spacer()
                            }
                            Divider()  // Separator line
                            
                            HStack {
                                Spacer()
                                Button{
                                    print("Reset to Default")
                                    
                                } label: {
                                    Text("Reset to Default")
                                }
                                Spacer()
                            }
                        }
                    }
                } //Form ends
            
        } //Outer stack ends
    }
}

struct AddInterviewView_Previews: PreviewProvider {
    static var previews: some View {
        AddInterviewView()
    }
}
