//
//  FetchedInterviewModel.swift
//  job hunter
//
//  Created by Qingyuan Ma on 12/18/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct FetchedInterviewModel: Identifiable, Equatable {
    var id: String
    var company: Company
    var jobTitle: String
    var startDate: Date
    var status: String
    var visaRequired: String?
    var locationPreference: String
    var relocationRequired: Bool
    var salary: SalaryInfo
    var pastRounds:  [RoundModel]
    var futureRounds:  [RoundModel]
    var favorite: Bool
    
    // Implement the static '==' function for Equatable
    static func ==(lhs: FetchedInterviewModel, rhs: FetchedInterviewModel) -> Bool {
        // Provide logic to determine if two FetchedInterviewModels are equal
        // For example:
        return lhs.id == rhs.id // if each model has a unique 'id' property
    }

    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.id = document.documentID
        if let companyInfo = data["company"] as? [String: String] {
            self.company = Company(
                name: companyInfo["name"] ?? "unknown",
                logo: companyInfo["logo"] ?? ""
            )
        } else {
            self.company = Company(name: "unknown")
        }
        
        self.jobTitle = data["title"] as? String ?? ""
        self.startDate = (data["startDate"] as? Timestamp)?.dateValue() ?? Date()
        self.status = data["status"] as? String ?? ApplicationStatus.ongoing.rawValue
        self.visaRequired = data["visa_required"] as? String
        self.locationPreference = data["work_location"] as? String ?? "onsite"
        self.relocationRequired = data["is_relocation"] as? Bool ?? false
        self.favorite = data["favorite"] as? Bool ?? false
        
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
    @Published var interviews = [FetchedInterviewModel]() {
        didSet {
            interviewsDidChange.send()
        }
    }
    @Published var isLoading = false
    @Published var error: String?
    
    var interviewsDidChange = PassthroughSubject<Void, Never>()
    
    //TODO: Cache the fetchInterviews results if no data change instead of just interviews.removeAll()
    func fetchInterviewsData() async throws {
        self.isLoading = true
        let timeoutInterval: TimeInterval = 10 // 10 seconds timeout
        
        // Start a timed block
        DispatchQueue.main.asyncAfter(deadline: .now() + timeoutInterval) {
            if self.isLoading { // Still loading after timeout
                self.isLoading = false
                self.error = "Request timed out"
                print("DispatchQueue.main.asyncAfter timeout")
                // Handle timeout scenario, such as canceling the request or showing an error message
            }
        }
        
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
                self.error = nil
                self.isLoading = false
                self.interviews.removeAll()
                self.interviews.append(contentsOf: documentsSnap.compactMap { document in FetchedInterviewModel(document: document) })
            }
            
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                self.isLoading = false // Also needs to be set here in case of error
            }
        }
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
            DispatchQueue.main.async {
                self.error = "Failed to Delete the Interview! \(error.localizedDescription)"
            }
        }
    } // Delete func ends
    
    func toggleFavorite(interviewId: String) async throws {
        // Find the index of the interview
        guard let index = interviews.firstIndex(where: { $0.id == interviewId }) else { return }
        
        // Toggle the favorite status
        let newFavoriteStatus = !interviews[index].favorite
        
        // Update the interview in Firestore
        try await AddInterviewManager.shared.updateInterviewField(
            on: "favorite", newData: newFavoriteStatus, interviewId: interviewId
        )
        
        DispatchQueue.main.async {
            var updatedInterview = self.interviews[index]
            updatedInterview.favorite = newFavoriteStatus
            self.interviews[index] = updatedInterview
            self.interviews = Array(self.interviews)
            // Notify subscribers that interviews have been updated
            self.interviewsDidChange.send()
           
        }
    }
}

//extension InterviewsViewModel {
//    var interviewsByCompany: [String: [FetchedInterviewModel]] {
//        Dictionary(grouping: interviews, by: { $0.company.name })
//    }
//}

extension FetchedInterviewModel {
    init(id: String, company: Company, jobTitle: String, startDate: Date, status: String, visaRequired: String?, locationPreference: String, relocationRequired: Bool, salary: SalaryInfo, pastRounds: [RoundModel], futureRounds: [RoundModel], favorite: Bool) {
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
        self.favorite = favorite
    }
    
    static func createSampleData(count: Int) -> [FetchedInterviewModel] {
        var samples = [FetchedInterviewModel]()
        
        for index in 1...count {
            let interview = FetchedInterviewModel(
                id: "\(index)",
                company: Company(name: "Company \(index)", logo: "https://logo.clearbit.com/microsoftcasualgames.com"),
                jobTitle: "Position Title \(index)",
                startDate: Date(),
                status: ["ongoing", "offer", "rejected"].randomElement() ?? "ongoing",
                visaRequired: index % 2 == 0 ? "Yes" : "No",
                locationPreference: index % 3 == 0 ? "Remote" : "Onsite",
                relocationRequired: index % 4 == 0,
                salary: SalaryInfo(base: Double.random(in: 70000...150000), bonus: Double.random(in: 0...0.3), equity: Double.random(in: 0...10000), signon: Double.random(in: 0...10000)),
                pastRounds: [], // You would add actual RoundModel data here if needed
                futureRounds: [], // Same as above,
                favorite: true
            )
            samples.append(interview)
            samples.append(interview)
        }
        
        return samples
    }
}

extension InterviewsViewModel {
    static func mockViewModel() -> InterviewsViewModel {
        let viewModel = InterviewsViewModel()
        viewModel.loadMockData()
        return viewModel
    }

    func loadMockData() {
        // Your mock data here
        self.interviews = FetchedInterviewModel.createSampleData(count: 5)
        self.isLoading = false
    }
}


