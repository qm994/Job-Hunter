//
//  AddInterviewView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/1/23.
//

import SwiftUI

enum ApplicationStatus: String, CaseIterable, Identifiable {
    case pending = "pending"
    case rejected = "rejected"
    case offer = "offer"
    
    var id: String {
        self.rawValue
    }
    
    var statusColor: Color {
        switch self {
            case .pending:
                .yellow
            case .rejected:
                .red
            case .offer:
                .green
        }
    }
}

struct BasicFields: View {
    
    @ObservedObject var sharedData: AddInterviewModel
    
    @StateObject var clearbitModel = ClearbitViewModel()
    
    let debouncer = Debouncer(delay: 1)
    
    private func color(for status: String) -> Color {
        
        guard let applicationStatus = ApplicationStatus(rawValue: status) else {
            return .black // Default color if there's an unknown status
        }
        print("applicationStatus: \(applicationStatus.statusColor)")
        return applicationStatus.statusColor
    }
    
    var body: some View {
        VStack {
            
            DropdownMenu(
                options: clearbitModel.companyList,
                dropDownLabel: "Company *",
                sharedData: sharedData
            ) { value in
                debouncer.debounce {
                    Task {
                        await clearbitModel.fetchCompaniesData(startwith: value)
                    }
                }
            }
            .zIndex(1)  // This will ensure the DropdownMenu appears on top of other views
            
            
            CustomizedTextField(label: "Job Title *", fieldPlaceHolder: "ex: Senior Software Enginer", fieldValue: $sharedData.jobTitle)
            
            DatePicker("Start Date *", selection: $sharedData.startDate, displayedComponents: [.date])
                .fontWeight(.bold)
                .foregroundColor(.blue)
        
            HStack {
                Text("Status")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Spacer()
                Picker("", selection: $sharedData.status) {
                    ForEach(ApplicationStatus.allCases) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
    
    
}



struct BasicFields_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            BasicFields(sharedData: AddInterviewModel())
        }
    }
}


