//
//  HomeScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/24/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FetchedInterviewModel: Identifiable {
    var id: String
    var company: String
    var jobTitle: String
    var startDate: Date
    var status: String
    var visaRequired: String?
    var locationPreference: String
    var relocationRequired: Bool
    var salary: SalaryInfo
    // Add other properties as needed

    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.id = document.documentID
        self.company = data["company"] as? String ?? ""
        self.jobTitle = data["title"] as? String ?? ""
        self.startDate = (data["startDate"] as? Timestamp)?.dateValue() ?? Date()
        self.status = data["status"] as? String ?? ""
        self.visaRequired = data["visa_required"] as? String
        self.locationPreference = data["work_location"] as? String ?? "onsite"
        self.relocationRequired = data["is_relocation"] as? Bool ?? false
        if let salaryData = data["salary"] as? [String: Double] {
            self.salary = SalaryInfo(
                base: salaryData["base"] ?? 0,
                bonus: salaryData["bonus"] ?? 0,
                equity: salaryData["equity"] ?? 0,
                signon: salaryData["signon"] ?? 0
            )
        } else {
            self.salary = SalaryInfo() // Default empty values
        }
        // Initialize other properties similarly
    }
}

class InterviewsViewModel: ObservableObject {
    @Published var interviews = [FetchedInterviewModel]()

    func fetchInterviews() async throws {
        // Firestore fetch logic
        // For each document snapshot, initialize a FetchedInterviewModel
        // Append each model to the interviews array
        guard let currentUser = try? AuthenticationManager.sharedAuth.getAuthenticatedUser() else {
            // Handle the case where currentUser is nil, either due to an error or no authenticated user
            return
        }
        if currentUser.uid == nil {
            return
        }
        
        print(currentUser.uid)
        
        let documentsSnap = try await FirestoreInterviewDataManager.shared.fetchInterviews(fromUser: currentUser.uid)
        
        interviews.append(contentsOf: documentsSnap.compactMap { document in FetchedInterviewModel(document: document)
        })
    }
}



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
                
//                try await FirestoreInterviewDataManager.shared.fetchInterviews(fromUser: authModel.userProfile?.userId)
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
            salary: SalaryInfo(base: 120000, bonus: 10000, equity: 5000, signon: 5000)
        )
    }
}
