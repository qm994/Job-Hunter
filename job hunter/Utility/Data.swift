//
//  Data.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/25/23.
//

import SwiftUI

struct MockInterview {
    let id: Int
    let company: Company
    let position: String
    let location: String
    let date: Date
    let type: String
    let recruiter: Contact
    let hiringManager: Contact?
    let interviewers: [Contact]
    let jobDescription: String
    let companyResearchLinks: [URL]
    let questionsPrepared: [String]
    let technicalTopics: [String]
    let interviewFeedback: String?
    let questionsAsked: [String]
    let followUpTasks: [String]
    let outcome: Outcome?
    let salaryOffered: Salary?
    let feedbackFromCompany: String?
    let decision: Decision?
    let platformDetails: Platform?
    let requiredDocuments: [Document]
    let reminders: [Date]
    let companyCultureNotes: String
    let networkingContacts: [Contact]
    let experienceRating: Int // e.g., 1-5
    //let attachments: [Attachment]
}

struct Contact {
    let name: String
    let email: String?
    let phoneNumber: String?
}

struct Outcome {
    let status: String // Offered, Rejected, Pending, etc.
    let date: Date
}

struct Salary {
    let base: Double
    let benefits: [String]
    let otherCompensation: String?
}

struct Decision {
    let status: String // Accepted, Declined, etc.
    let reason: String?
}

struct Platform {
    let platformName: String // Zoom, Teams, etc.
    let link: URL
    let password: String?
}

struct Document {
    let name: String
    let date: Date
    let link: URL?
}

struct Company {
    let name: String
    let website: URL
    let logo: String
}

//struct Attachment {
//    let type: String // Resume, Cover Letter, Portfolio, etc.
//    let link: URL
//}

// Example of mock data instance:

let mockInterview1 = MockInterview(
    id: 1,
    company: Company(
        name: "Google",
        website: URL(string: "https://www.google.com")!,
        logo: "google"),
    position: "Front-end Developer",
    location: "Remote",
    date: Date(),
    type: "Virtual Technical Round",
    recruiter: Contact(name: "Jane Doe", email: "jane@techcorp.com", phoneNumber: "123-456-7890"),
    hiringManager: Contact(name: "John Smith", email: "john@techcorp.com", phoneNumber: nil),
    interviewers: [Contact(name: "Alice", email: nil, phoneNumber: nil)],
    jobDescription: "Responsible for developing and maintaining the company's main website...",
    companyResearchLinks: [URL(string: "https://www.techcorp.com/news")!],
    questionsPrepared: ["What's the team structure?", "How do you handle code reviews?"],
    technicalTopics: ["React", "TypeScript", "GraphQL"],
    interviewFeedback: "Went well. Need to brush up on GraphQL queries.",
    questionsAsked: ["Describe a challenge you faced in a project and how you overcame it."],
    followUpTasks: ["Send thank-you email", "Prepare for next round"],
    outcome: Outcome(status: "Pending", date: Date().addingTimeInterval(604800)), // Pending and expecting an update in a week
    salaryOffered: nil,
    feedbackFromCompany: nil,
    decision: nil,
    platformDetails: Platform(platformName: "Zoom", link: URL(string: "https://zoom.us/meeting")!, password: "password123"),
    requiredDocuments: [Document(name: "Updated Resume", date: Date().addingTimeInterval(-172800), link: nil)], // Required 2 days ago
    reminders: [Date().addingTimeInterval(3600)], // Reminder set for 1 hour before the interview
    companyCultureNotes: "Seems to have a flexible work culture with opportunities for growth.",
    networkingContacts: [Contact(name: "Bob", email: "bob@techcorp.com", phoneNumber: nil)],
    experienceRating: 4
)

