//
//  RoundModel.swift
//  job hunter
//
//  Created by Qingyuan Ma on 12/29/23.
//

import Foundation
import FirebaseFirestore

class RoundModel: Encodable, ObservableObject, Equatable {
    var name: String
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var notes: String
    
    init(
        name: String,
        startDate: Date = Date(),
        endDate: Date = Date(),
        notes: String = ""
        
    ) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
        
    }
    
    // Additional initializer to decode from a dictionary
    required init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let startDateTimestamp = dictionary["start_date"] as? Timestamp, // Assuming start_date is a Timestamp
              let endDateTimestamp = dictionary["end_date"] as? Timestamp, // Assuming end_date is a Timestamp
              let notes = dictionary["notes"] as? String else {
            return nil
        }
        
        self.name = name
        self.startDate = startDateTimestamp.dateValue()
        self.endDate = endDateTimestamp.dateValue()
        self.notes = notes
    }
    
    // Equatable Conformance
    static func == (lhs: RoundModel, rhs: RoundModel) -> Bool {
        return lhs.name == rhs.name &&
        lhs.startDate == rhs.startDate &&
        lhs.endDate == rhs.endDate &&
        lhs.notes == rhs.notes
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case startDate = "start_date"
        case endDate = "end_date"
        case notes
    }
    
    /**
     When call Firestore.Encoder on the instance:
     encode(to:) function implemented will be used, and it will take precedence over the default behavior defined by the Firestore.Encoder's keyEncodingStrategy.
     */
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(notes, forKey: .notes)
    }
}
