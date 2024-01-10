//
//  AddInterviewModel.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/5/23.
//

import SwiftUI
import Combine
import FirebaseFirestore

struct Round {
    let id = UUID()
    let roundName: String
    let roundDate: Date = Date()
}

struct Company {
    var name: String
    var website: URL?
    var logo: String?
}


class AddInterviewModel: ObservableObject {
    
    @Published var company: Company = Company(name: "")
    @Published var jobTitle = ""
    @Published var startDate: Date = Date()
    @Published var status: ApplicationStatus = .pending
    
    @Published var needVisaSponsor: Bool = false
    @Published var requiredVisa: String? = nil
    @Published var locationPreference: String = "onsite" // onsite / remote/ hybrid
    @Published var relocationRequired: String = "NO" // YES / NO
    @Published var addExpectedSalary: Bool = false
    
    @Published var companyMissing: Bool = false
    @Published var jobTitleMissing: Bool = false
    
    @Published var errorAddInterview: String? = nil
    @Published var existingInterviewId: String? = nil
    
    func validateFields() {
        companyMissing = company.name.isEmpty
        jobTitleMissing = jobTitle.isEmpty
    }

    
    private func encodeInterviewData(salary: SalaryInfo) -> [String: Any] {
        let is_relocation: Bool = {
            switch relocationRequired.lowercased() {
            case "yes":
                return true
            case "no":
                return false
            default:
                return false // You can decide on a default value (true/false) or throw an error if needed.
            }
        }()
        
        // Convert to dictionary
        let salaryInfoDict: [String: Double] = [
            "base": salary.base,
            "bonus": salary.bonus,
            "equity": salary.equity,
            "signon": salary.signon
        ]

        
        let data: [String: Any]  = [
            "company": company.name,
            "title": jobTitle,
            "startDate": startDate,
            "is_relocation": is_relocation,
            "work_location": locationPreference,
            "status": status.rawValue,
            "salary": salaryInfoDict,
            "visa_required": requiredVisa ?? ""
        ]
        return data
    }
    
    func manageInterviewInFirestore(user: DBUser, salary: SalaryInfo, pastRounds: [RoundModel], futureRounds: [RoundModel], isUpdate: Bool = false) async throws {
        var data: [String: Any] = encodeInterviewData(salary: salary)
        if isUpdate, let interviewId = existingInterviewId {
            // Update existing interview
             try await AddInterviewManager.shared.updateInterview(
                user: user, data: &data, pastRounds: pastRounds, futureRounds: futureRounds, interviewId: interviewId
            )
        } else {
            // Add new interview
             try await AddInterviewManager.shared.createInterview(
                user: user, data: &data, pastRounds: pastRounds, futureRounds: futureRounds
            )
        }
    }
    
}


