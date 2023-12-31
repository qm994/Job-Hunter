//
//  CardView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/8/23.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var coreModel: CoreModel
    @ObservedObject var interviewsViewModel: InterviewsViewModel
    
    let interview: FetchedInterviewModel
    
    var body: some View {
        VStack(spacing: 20) {
            //MARK: FIRST ROW
            HStack {
                Text(interview.company)
                    .font(.headline)
                Spacer()
                HStack {
                    Text("Status:")
                    Text(interview.status)
                        .foregroundColor(ApplicationStatus(rawValue: interview.status)?.statusColor ?? .black)
                        
                }
            }
            .font(.headline)
            //MARK: Second row
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "briefcase.circle")
                        Text(interview.jobTitle)
                            .lineLimit(1)
                    }
                    HStack {
                        Image(systemName: "location.circle")
                        Text(interview.locationPreference)
                    }
                    HStack {
                        Image(systemName: "clock.badge.checkmark")
                        Text(formatDateWithoutTime(interview.startDate))
                    }
                }
                
                Spacer()
                VStack(alignment: .leading) {
                    CheckmarkView(
                        imageName: interview.visaRequired != nil ? "checkmark.circle.fill" : "xmark.circle.fill",
                        text: "Sponsor visa",
                        isPositive: interview.visaRequired != nil
                    )
                    CheckmarkView(
                        imageName: interview.relocationRequired ? "checkmark.circle.fill" : "xmark.circle.fill",
                        text: "Need relocation",
                        isPositive: interview.relocationRequired
                    )
                    CheckmarkView(
                        imageName: interview.locationPreference == "remote" ? "checkmark.circle.fill" : "xmark.circle.fill",
                        text: "Remote available",
                        isPositive: interview.locationPreference == "remote"
                    )
                }
            } // Second row ends
            .font(.subheadline)
            
            //MARK: 3rd row
            CardSalarySection(interview: interview)
            
        }// Root VSTACK ENDS
        .padding()
        .background(BlurView(style: .systemThickMaterialDark))
        .cornerRadius(15)
        .shadow(color: Color.white.opacity(0.2), radius: 15, x: 0, y: 10)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                coreModel.path.append(NavigationPath.addInterviewScreen.rawValue)
                coreModel.editInterview = interview
                
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)

            Button(role: .destructive) {
                // Handle delete action
                Task {
                    try await interviewsViewModel.deleteInterviewAndUpdate(
                        interviewId: interview.id
                    )
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct CardSalarySection: View {
    @State var showDetails: Bool = false
    var interview: FetchedInterviewModel
    
    var otherExpected: Double {
        return interview.salary.equity / 4 + interview.salary.base * interview.salary.bonus + interview.salary.signon
    }
    
    var totalExpected: Double {
        return otherExpected + interview.salary.base
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            //MARK: Total Compensation header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showDetails.toggle()
                }
            }) {
                HStack {
                    // Arrow symbol
                   Image(systemName: showDetails ? "chevron.down" : "chevron.right")
                       .foregroundColor(.gray)
                       .onTapGesture {
                           withAnimation {
                               showDetails.toggle()
                           }
                       }
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.green)
                    Text("Total Compensation: \(formatNumber(totalExpected))")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.bold)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 0.68, green: 0.85, blue: 0.90))
            }
            .buttonStyle(.bordered)

            if showDetails {
                VStack(alignment: .leading) {
                    // base pay
                    HStack(spacing: 5) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("Base expect:")
                        }

                        Text(String(interview.salary.base))
                    }
                    .foregroundColor(Color("usDollarGreen"))
                    
                    // Euqity
                    HStack(spacing: 5) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("Equity 4 Years:")
                        }

                        Text(String(interview.salary.equity))
                    }
                    .foregroundColor(Color("usDollarGreen"))
                    
                    // Bonus
                    HStack(spacing: 5) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("Yearly Bonus %:")
                        }

                        Text("\(Int(interview.salary.bonus * 100))%")
                    }
                    .foregroundColor(Color("usDollarGreen"))
                    
                    // Signon
                    HStack(spacing: 5) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("Sign on:")
                        }

                        Text(String(interview.salary.signon))
                    }
                    .foregroundColor(Color("usDollarGreen"))
                    
                    
                    //MARK: Total Pay
                    HStack(spacing: 5) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("Total / Year:")
                        }

                        Text(String(totalExpected))
                    }
                    .foregroundColor(Color("usDollarGreen"))
                } // ShowDetails vstack ends
                .transition(AnyTransition.slide.combined(with: .opacity).animation(.easeInOut(duration: 0.5)))

            }
        }
    }
}

struct CheckmarkView: View {
    var imageName: String
    var text: String
    var isPositive: Bool // Determines the color

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(isPositive ? .green : .red)
            Text(text)
        }
    }
}


struct CardView_Previews: PreviewProvider {
    //@StateObject var interviewsViewModel = InterviewsViewModel()
    static var previews: some View {
        List{
            CardView(
                interviewsViewModel: InterviewsViewModel(),
                interview: FetchedInterviewModel.sampleData
            )
            .environmentObject(CoreModel())
        }
        .listStyle(.plain)
    }
}
