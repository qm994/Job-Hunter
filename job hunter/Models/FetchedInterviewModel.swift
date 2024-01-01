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
    var pastRounds:  [RoundModel]
    var futureRounds:  [RoundModel]

    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.id = document.documentID
        self.company = data["company"] as? String ?? ""
        self.jobTitle = data["title"] as? String ?? ""
        self.startDate = (data["startDate"] as? Timestamp)?.dateValue() ?? Date()
        self.status = data["status"] as? String ?? ApplicationStatus.pending.rawValue
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
        
       
        if let pastRoundsArray = data["pastRounds"] as? [[String: Any]] {
            self.pastRounds = pastRoundsArray.compactMap { RoundModel(dictionary: $0) }
        } else {
            self.pastRounds = []
        }

        if let futureRoundsArray = data["futureRounds"] as? [[String: Any]] {
            self.futureRounds = futureRoundsArray.compactMap { RoundModel(dictionary: $0) }
        } else {
            self.futureRounds = []
        }
    }
}

class InterviewsViewModel: ObservableObject {
    @Published var interviews = [FetchedInterviewModel]()
    @Published var isLoading = false
    @Published var error: String?

    //TODO: Cache the fetchInterviews results if no data change instead of just interviews.removeAll()
    func fetchInterviewsData() async throws {
        self.isLoading = true
        // Firestore fetch logic
        // For each document snapshot, initialize a FetchedInterviewModel
        // Append each model to the interviews array
        do {
            guard let currentUser = try AuthenticationManager.sharedAuth.getAuthenticatedUser() else {
                throw NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"])
            }
            
            let documentsSnap = try await FirestoreInterviewDataManager.shared.fetchInterviews(
                fromUser: currentUser.uid
                //fromUser: "testError"
            )
            
            DispatchQueue.main.async {
                guard let documentsSnap = documentsSnap else {
                    self.interviews = []
                    self.error = nil
                    self.isLoading = false
                    return
                }
                // Clear the old data only when new data is successfully fetched
                self.interviews.removeAll()
                self.interviews.append(contentsOf: documentsSnap.compactMap { document in FetchedInterviewModel(document: document) })
                self.error = nil // Clear any existing error
            }
            
        } catch {
            self.error = error.localizedDescription
        }
        
        self.isLoading = false
    }
    
    func deleteInterviewAndUpdate(interviewId: String) async throws {
        do {
            guard let currentUser = try AuthenticationManager.sharedAuth.getAuthenticatedUser() else {
                throw NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"])
            }
            
            try await FirestoreInterviewDataManager.shared.deleteInterview(from: currentUser.uid, with: interviewId)
            
            // If the delete operation succeeds, remove the interview from the interviews array
            DispatchQueue.main.async {
                self.interviews.removeAll { $0.id == interviewId }
            }
        } catch let error {
            self.error = "Failed to Delete the Interview! \(error.localizedDescription)"
        }
        
    }
}

extension FetchedInterviewModel {
    init(id: String, company: String, jobTitle: String, startDate: Date, status: String, visaRequired: String?, locationPreference: String, relocationRequired: Bool, salary: SalaryInfo, pastRounds: [RoundModel], futureRounds: [RoundModel]) {
        self.id = id
        self.company = company
        self.jobTitle = jobTitle
        self.startDate = startDate
        self.status = status
        self.visaRequired = visaRequired
        self.locationPreference = locationPreference
        self.relocationRequired = relocationRequired
        self.salary = salary
        self.pastRounds = pastRounds
        self.futureRounds = futureRounds
    }
    
    static var sampleData: FetchedInterviewModel {
        return FetchedInterviewModel(
            id: "1",
            company: "Sample Company",
            jobTitle: "Senior Software Engineer with long title",
            startDate: Date(),
            status: "pending",
            visaRequired: "H1B",
            locationPreference: "Remote",
            relocationRequired: true,
            salary: SalaryInfo(base: 120000, bonus: 0.2, equity: 5000, signon: 5000),
            pastRounds: [],
            futureRounds: []
        )
    }
}

