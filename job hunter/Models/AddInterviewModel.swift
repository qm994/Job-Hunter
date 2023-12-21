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
    @Published var locationPreference: String = "onsite"
    @Published var relocationRequired: String = "NO"
    @Published var addExpectedSalary: Bool = false 
    
    @Published var companyMissing: Bool = false
    @Published var jobTitleMissing: Bool = false
    
    func validateFields() {
        companyMissing = company.name.isEmpty
        jobTitleMissing = jobTitle.isEmpty
    }

    

    //TODO: Build encode and decode for data
    /// Create Interview to the FireStore:
    /// (1)Add interview document id to the user's document interviews field array
    /// (2) Add past rounds as to the sub collection of pastRounds 
    func addInterviewToFirestore(user: DBUser, salary: SalaryInfo, pastRounds: [RoundModel], futureRounds: [RoundModel]) async throws {
        
        let is_relocation: Bool = {
            switch relocationRequired.lowercased() {
            case "true":
                return true
            case "false":
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

        
        var data: [String: Any]  = [
            "company": company.name,
            "title": jobTitle,
            "startDate": startDate,
            "is_relocation": is_relocation,
            "work_location": locationPreference,
            "status": status.rawValue,
            "salary": salaryInfoDict,
            "visa_required": requiredVisa ?? ""
        ]
        
        let interviewDocument = try await AddInterviewManager.shared.createInterview(user: user, data: &data)
        // Create pastRounds subCollection in interview document
        try await AddInterviewManager.shared.addPastRounds(
            to: interviewDocument.documentID,
            pastRounds: pastRounds
        )
        return try await AddInterviewManager.shared.addFutureRounds(
            to: interviewDocument.documentID,
            futureRounds: futureRounds
        )
    }
    
}


