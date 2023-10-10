//
//  SampleData.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/8/23.
//

import Foundation


extension Interview {
    static let sampleData: [Interview] = [
        Interview(
            id: UUID(),
            job: Job(
                id: UUID(),
                title: "Software Engineer",
                company: Company(name: "Company A", website: URL(string: "https://companya.com"), logo: "logoA"),
                location: .remote,
                apppliedDate: Date(),
                reference: Reference(contact: Contact(name: "John Doe", email: "john@example.com", phoneNumber: "123-456-7890"), relationship: "Colleague"),
                expectedSalary: Salary(baseRange: "80000", otherCompensation: "4000"),
                sponsorStatus: SponsorStatus(doesSponsor: true, sponsoredVisaTypes: [.H1B], doesSponsorGreenCard: true, greenCardFromDayOne: false)
            ),
            jobDescription: "Full-stack development",
            status: .offered,
            experienceRating: 5
        ),
        Interview(
            id: UUID(),
            job: Job(
                id: UUID(),
                title: "Data Scientist",
                company: Company(name: "Company B", website: URL(string: "https://companyb.com"), logo: "logoB"),
                location: .hybrid,
                apppliedDate: Date(),
                reference: Reference(contact: Contact(name: "Jane Doe", email: "jane@example.com", phoneNumber: "987-654-3210"), relationship: "Friend"),
                expectedSalary: nil,
                sponsorStatus: nil
            ),
            jobDescription: "Data analysis and machine learning",
            status: .rejected,
            experienceRating: 3
        ),
        Interview(
            id: UUID(),
            job: Job(
                id: UUID(),
                title: "Product Manager",
                company: Company(name: "Company C", website: URL(string: "https://companyc.com"), logo: "logoC"),
                location: .onsite,
                apppliedDate: Date(),
                reference: Reference(contact: Contact(name: "Emily Doe", email: "emily@example.com", phoneNumber: "111-222-3333"), relationship: "Former Boss"),
                expectedSalary: Salary(baseRange: "100000", otherCompensation: "80000"),
                sponsorStatus: SponsorStatus(doesSponsor: false, sponsoredVisaTypes: [], doesSponsorGreenCard: false, greenCardFromDayOne: false)
            ),
            jobDescription: "Product planning and strategy",
            status: .pending,
            experienceRating: 4
        )
    ]
}
