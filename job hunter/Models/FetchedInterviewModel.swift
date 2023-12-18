//
//  FetchedInterviewModel.swift
//  job hunter
//
//  Created by Qingyuan Ma on 12/18/23.
//

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

    //TODO: Cache the fetchInterviews results if no data change instead of just interviews.removeAll()
    func fetchInterviews() async throws {
        interviews.removeAll()
        // Firestore fetch logic
        // For each document snapshot, initialize a FetchedInterviewModel
        // Append each model to the interviews array
        guard let currentUser = try? AuthenticationManager.sharedAuth.getAuthenticatedUser() else {
            // Handle the case where currentUser is nil, either due to an error or no authenticated user
            return
        }
      
        let documentsSnap = try await FirestoreInterviewDataManager.shared.fetchInterviews(fromUser: currentUser.uid)
        
        interviews.append(contentsOf: documentsSnap.compactMap { document in FetchedInterviewModel(document: document)
        })
    }
}

