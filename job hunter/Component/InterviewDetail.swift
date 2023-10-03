//
//  InterviewDetail.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/25/23.
//

import SwiftUI

struct InterviewDetailView: View {
    var interview: MockInterview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Company Name and Position
            VStack(alignment: .leading) {
                Image(interview.company.logo)
                    .resizable().scaledToFit()
                    .frame(width: 100, height: 100)

                Text(interview.company.name)
                    .font(.title)
                    .foregroundColor(.primary)
                Text(interview.position)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Date and Time
            Text("Date: \(formattedDate(from: interview.date))")
            
            // Interview Type
            Text("Type: \(interview.type)")
            
            // Recruiter's Details
            VStack(alignment: .leading) {
                Text("Recruiter: \(interview.recruiter.name)")
                Text("Email: \(interview.recruiter.email ?? "N/A")")
                Text("Phone: \(interview.recruiter.phoneNumber ?? "N/A")")
            }
            
            // Feedback
            if let feedback = interview.interviewFeedback {
                Text("Feedback:")
                    .font(.headline)
                Text(feedback)
            }
            
            Spacer()
        }
        .padding()
    }
    
    // Helper function to format the date
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct InterviewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InterviewDetailView(interview: mockInterview1)
    }
}
