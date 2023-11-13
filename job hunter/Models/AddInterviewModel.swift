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

class AddInterviewModel: ObservableObject {
    
    
    @Published var company: Company
    
    @Published var jobTitle = ""
    @Published var startDate: Date = Date()
    @Published var status: ApplicationStatus = .pending
    
    @Published var locationPreference: String = ""
    @Published var relocationRequired: String = ""
    @Published var addExpectedSalary: Bool = false 
    
    
    /*
     When add one past round, always use the top one as the newly add one
     */
    @Published var allRounds: [String] = AllRounds
    
    @Published var pastRounds: PastRoundsModel = PastRoundsModel()
    
    @Published var futureRounds: FutureRoundsModel = FutureRoundsModel()
    
    private var cancellables = Set<AnyCancellable>()
    private var roundNameCancellables = Set<AnyCancellable>()
    
    
    // sink return a cancellable instance which has to be stored so keep the observable updates alive
    init() {
        self.company = Company(name: "")
        
        self.pastRounds.objectWillChange.sink { [weak self] _ in
            //self.company = Company(name: "")
            self?.objectWillChange.send()
        }.store(in: &cancellables)

        self.futureRounds.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        
        /*
         Used for the interaction between pastRounds and futruRounds
         */
        self.pastRounds.$rounds.sink {[weak self] newPastRounds in
            // Remove old roundName subscriptions
        
            
            /*
             Instead of removing all Cancellable objects, you might want to keep track of the ones related to roundName separately and only remove those when needed.
             */
            self?.roundNameCancellables.removeAll()
            
            // Subscribe to roundName changes for each RoundData object
            for round in newPastRounds {
                round.$roundName.sink {[weak self] newRound in
                    self?.updateFutureRounds(with: newPastRounds)
                }.store(in: &self!.roundNameCancellables)
            }
        }.store(in: &cancellables)
        
    }
    
    private func updateFutureRounds(with newPastRounds: [RoundData]) {
        let existingRoundNames = newPastRounds.map { $0.roundName }
        print("updateFutureRounds existingRoundNames: \(existingRoundNames)")
        futureRounds.rounds = allRounds.filter { !existingRoundNames.contains($0) }
    }
    
    
    
    //TODO: Build encode and decode for data
    // Add Interview to the FireStore and add its document id to the user's interviews array
    func addInterviewToFirestore(user: DBUser, salary: SalaryInfo) async throws {
        
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
            "salary": salaryInfoDict
        ]
        
        return try await AddInterviewManager.shared.createInterview(user: user, data: &data)
    }
    
}

class FutureRoundsModel: ObservableObject {
    @Published var rounds: [String] = AllRounds
    @Published var selectedRounds: [ExtendedRoundData] = []
    //@Published var roundsTest: [ExtendedRoundData] = []
}

class PastRoundsModel:ObservableObject {
    @Published var rounds: [RoundData] = []
}


class RoundData: ObservableObject, CustomStringConvertible {
    let id = UUID()
    @Published var roundName = ""
    @Published var roundTime = Date()
    
    var description: String {
           return "Round Name: \(roundName), roundTime: \(roundTime), id is: \(id)"
       }
}

class ExtendedRoundData: RoundData {
    @Published var isChecked: Bool = false
}


