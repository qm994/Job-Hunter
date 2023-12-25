//
//  AddInterviewButton.swift
//  job hunter
//
//  Created by Qingyuan Ma on 11/20/23.
//

import SwiftUI

struct AddInterviewButton: View {
    @EnvironmentObject var authModel: AuthenticationModel
    @EnvironmentObject var addInterviewModel: AddInterviewModel
    @EnvironmentObject var coreModel: CoreModel
    
    var salaryModel: SalarySectionModel
    var roundModel: InterviewRoundsModel
    
    var body: some View {
        Button("Add") {
            Task {
                do {
                    guard let userProfile = authModel.userProfile else {
                        print("User profile is not available")
                        return
                    }
                    
                    addInterviewModel.validateFields()
                    if addInterviewModel.companyMissing || addInterviewModel.jobTitleMissing {
                        print("Required fields are missing")
                        return
                    }
                    
                    // Extract salary info if enabled
                    let salaryInfo = SalaryInfo(
                        base:  addInterviewModel.addExpectedSalary ? salaryModel.base : 0,
                        bonus: addInterviewModel.addExpectedSalary ? salaryModel.bonus : 0,
                        equity: addInterviewModel.addExpectedSalary ? salaryModel.equity: 0,
                        signon: addInterviewModel.addExpectedSalary ? salaryModel.signon : 0
                    )
                    
                    //Add interview and its sub collections: pastRounds and futureRounds
                    
                    try await addInterviewModel.addInterviewToFirestore(
                        user: userProfile,
                        salary: salaryInfo,
                        pastRounds: roundModel.pastRounds,
                        futureRounds: roundModel.futureRounds
                    )
                    
                    // Move back to main screen
                    coreModel.path.removeAll { pathName in
                        pathName == NavigationPath.addInterviewScreen.rawValue
                    }
                    print("Interview added successfully")
                } catch {
                    // Handle the error appropriately
                    print("Error adding interview: \(error)")
                }
            }
        }

    }
}
