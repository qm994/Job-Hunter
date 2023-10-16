//
//  InterviewModel.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/8/23.
//

import Foundation
import SwiftUI


struct Interview: Identifiable {
    let id: UUID
    var job: Job
    var jobDescription: String
    var status: InterviewStatus
    var experienceRating: Int // e.g., 1-5
}

struct Job {
    var id: UUID
    var title: String
    var company: Company
    var location: JobLocation
    var apppliedDate: Date
    var reference: Reference
    var expectedSalary: Salary?
    var sponsorStatus: SponsorStatus?
}

struct Company {
    var name: String
    var website: URL?
    var logo: String?
}

enum VisaType: String {
    case H1B = "H1B"
    case OPT = "OPT"
}

struct Salary {
    let baseRange: String
    let otherCompensation: String?
}

struct SponsorStatus {
    var doesSponsor: Bool
    var sponsoredVisaTypes: [VisaType]
    var doesSponsorGreenCard: Bool
    var greenCardFromDayOne: Bool
    
    init(doesSponsor: Bool = false,
         sponsoredVisaTypes: [VisaType] = [],
         doesSponsorGreenCard: Bool = false,
         greenCardFromDayOne: Bool = false) {
        
        self.doesSponsor = doesSponsor
        self.sponsoredVisaTypes = sponsoredVisaTypes
        self.doesSponsorGreenCard = doesSponsorGreenCard
        self.greenCardFromDayOne = greenCardFromDayOne
    }
}

struct Reference {
    var contact: Contact
    var relationship: String
    
    // Accessors for Contact properties
    var name: String {
        return contact.name
    }
    
    var email: String? {
        return contact.email
    }
    
    var phoneNumber: String? {
        return contact.phoneNumber
    }
}

enum JobLocation: String, CaseIterable {
    case remote = "Remote"
    case hybrid = "Hybrid"
    case onsite = "Onsite"
}

enum InterviewStatus: String, CaseIterable {
    case offered = "Offered"
    case rejected = "Rejected"
    case pending = "Pending"
    
    var iconName: String {
        switch self {
        case .offered:
            return "hand.thumbsup.circle"
        case .rejected:
            return "xmark.shield"
        case .pending:
            return "hourglass.circle"
        
        }
    }
    
    var textColor: Color {
        switch self {
        case .offered:
            return Color.green
        case .rejected:
            return Color.red
        case .pending:
            return Color.yellow
        }
    }
}
