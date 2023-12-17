//
//  CardView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/8/23.
//

import SwiftUI

struct CardView: View {
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
                    Label(interview.jobTitle, systemImage: "briefcase.circle")
                    Label(interview.locationPreference, systemImage: "location.circle")
                    Label(formatDateWithoutTime(interview.startDate), systemImage: "clock.badge.checkmark")
                }
                
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Text("Visa Sponsor")
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    
                    HStack {
                        Text("Relocation Required")
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    HStack {
                        Text("Remote availablew")
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
                
            } // Second row ends
            .font(.subheadline)
            
            //MARK: 3rd row
            CardSalarySection(interview: interview)
            
        }// Root VSTACK ENDS
        .padding()
        .background(BlurView(style: .systemThickMaterialDark))
        .cornerRadius(15)
        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 10)
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

                        Text(String(interview.salary.bonus * 100))
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

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(interview: FetchedInterviewModel.sampleData)
            //.previewLayout(.fixed(width: 400, height: 60))
    }
}
