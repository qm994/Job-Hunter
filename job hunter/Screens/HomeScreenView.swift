//
//  HomeScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/24/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct HomeScreenView: View {
    
    @EnvironmentObject var authModel: AuthenticationModel
    @StateObject var interviewsViewModel: InterviewsViewModel = InterviewsViewModel()
    
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            ScrollView {
                ForEach(interviewsViewModel.interviews, id: \.self.id) { interview in
                    CardView(interview: interview)
                }
            }
        }
        .onAppear {
            Task {
                try await authModel.loadCurrentUser()
                try await interviewsViewModel.fetchInterviews()
                
            }
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let interviewsViewModel = InterviewsViewModel()

        HomeScreenView(interviewsViewModel: interviewsViewModel)
            .environmentObject(AuthenticationModel())
    }
}


extension FetchedInterviewModel {
    init(id: String, company: String, jobTitle: String, startDate: Date, status: String, visaRequired: String?, locationPreference: String, relocationRequired: Bool, salary: SalaryInfo) {
        self.id = id
        self.company = company
        self.jobTitle = jobTitle
        self.startDate = startDate
        self.status = status
        self.visaRequired = visaRequired
        self.locationPreference = locationPreference
        self.relocationRequired = relocationRequired
        self.salary = salary
    }
    
    static var sampleData: FetchedInterviewModel {
        return FetchedInterviewModel(
            id: "1",
            company: "Sample Company",
            jobTitle: "Software Engineer",
            startDate: Date(),
            status: "pending",
            visaRequired: "H1B",
            locationPreference: "Remote",
            relocationRequired: true,
            salary: SalaryInfo(base: 120000, bonus: 0.2, equity: 5000, signon: 5000)
        )
    }
}
