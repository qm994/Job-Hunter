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
    
    var isUpdate: Bool = false
    
    var body: some View {
        Button(isUpdate ? "Update" : "Add") {
            
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
                    
                    if (isUpdate) {
                        try await addInterviewModel.manageInterviewInFirestore(
                            user: userProfile,
                            salary: salaryInfo,
                            pastRounds: roundModel.pastRounds,
                            futureRounds: roundModel.futureRounds,
                            isUpdate: isUpdate
                        )
                    } else {
                        try await addInterviewModel.manageInterviewInFirestore(
                            user: userProfile,
                            salary: salaryInfo,
                            pastRounds: roundModel.pastRounds,
                            futureRounds: roundModel.futureRounds,
                            isUpdate: isUpdate
                        )
                    }
                    // Move back to main screen and clear the form
                    DispatchQueue.main.async {
                        coreModel.path.removeAll { pathName in
                            pathName == NavigationPath.addInterviewScreen.rawValue
                        }
                        addInterviewModel.existingInterviewId = nil
                        coreModel.editInterview = nil
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
