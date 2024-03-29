//
//  AddInterviewView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/1/23.
//

import SwiftUI

enum ApplicationStatus: String, CaseIterable, Identifiable {
    case ongoing = "ongoing"
    case rejected = "rejected"
    case offer = "offer"
    
    var id: String {
        self.rawValue
    }
    
    var statusColor: Color {
        switch self {
            case .ongoing:
                .yellow
            case .rejected:
                .red
            case .offer:
                .green
        }
    }
}

struct BasicFields: View {
    
    @EnvironmentObject var addInterviewModel: AddInterviewModel
    
    @StateObject var clearbitModel = ClearbitViewModel()
    
    let debouncer = Debouncer(delay: 1)
    
    private func color(for status: String) -> Color {
        
        guard let applicationStatus = ApplicationStatus(rawValue: status) else {
            return .black // Default color if there's an unknown status
        }
        return applicationStatus.statusColor
    }
    
    var body: some View {
        VStack {
            
            DropdownMenu(
                dropDownLabel: "Company *"
            ) { value in
                debouncer.debounce {
                    Task {
                        await clearbitModel.fetchCompaniesData(startwith: value)
                    }
                }
            }
            .zIndex(1)  // This will ensure the DropdownMenu appears on top of other views
            .environmentObject(clearbitModel)
            
            
            CustomizedTextField(
                label: "Job Title *",
                fieldPlaceHolder: "ex: Senior Software Enginer",
                fieldValue: $addInterviewModel.jobTitle,
                showBorderWarning: addInterviewModel.jobTitleMissing
            ) {
                if (addInterviewModel.jobTitleMissing) {
                    addInterviewModel.jobTitleMissing = false
                }
            }
            
            DatePicker("Applied On", selection: $addInterviewModel.startDate, displayedComponents: [.date])
                .fontWeight(.bold)
        
            HStack {
                Text("Status")
                    .fontWeight(.bold)
                
                Spacer()
                
                Picker("", selection: $addInterviewModel.status) {
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
            BasicFields()
                .environmentObject(AddInterviewModel())
        }
    }
}


