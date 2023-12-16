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
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(interview.company)
                        .font(.headline)
                    
                    VStack(alignment: .leading) {
                        Label(interview.jobTitle, systemImage: "briefcase.circle")
                        Label(interview.locationPreference, systemImage: "location.circle")
                        Label(formatDateWithoutTime(interview.startDate), systemImage: "clock.badge.checkmark")
                    }
                    .font(.caption)
                }// First row 1ST VStack end
                
                Spacer()
                
                //MARK: 1ST ROW'S 2ND COL
                VStack(alignment: .leading, spacing: 10) {
                    //status
                    HStack(spacing: 5) {  // You can adjust the spacing value as per your need
                        HStack {
                            Image(systemName: interview.status)
                            Text("Status:")
                                
                        }
                        Text(interview.status)
                    }
                    .foregroundColor(ApplicationStatus(rawValue: interview.status)?.statusColor ?? .black)
                    .font(.headline)
                    
                    CardSalarySection(interview: interview)
                    
                } // First row 2nd VStack end
            } //FIRST ROW ENDS
            
            CardFooterView()
            
            
        }// Root VSTACK ENDS
        .padding()
        .background(BlurView(style: .systemThickMaterialDark))
        .cornerRadius(15)
        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct CardSalarySection: View {
    var interview: FetchedInterviewModel
    
    var otherExpected: Double {
        return interview.salary.equity / 4 + interview.salary.base * interview.salary.bonus + interview.salary.signon
    }
    
    var totalExpected: Double {
        return otherExpected + interview.salary.base
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // pay
            HStack(spacing: 5) {  // You can adjust the spacing value as per your need
                HStack {
                    Image(systemName: "dollarsign.circle")
                    Text("Base expect:")
                }

                Text(String(interview.salary.base))
            }
            .foregroundColor(Color("usDollarGreen"))
            .font(.caption)
            
            // other comp
            HStack(spacing: 5) {  // You can adjust the spacing value as per your need
                HStack {
                    Image(systemName: "dollarsign.circle")
                    Text("Misc<bonus, stock etc>:")
                }

                Text(String(otherExpected))
            }
            .foregroundColor(Color("usDollarGreen"))
            .font(.caption)
            
            //TODO: SHOW THE Increase/Decrease percent compare with user's current TC
            //MARK: Total Pay
            HStack(spacing: 5) {  // You can adjust the spacing value as per your need
                HStack {
                    Image(systemName: "dollarsign.circle")
                    Text("Total expect:")
                }

                Text(String(totalExpected))
            }
            .foregroundColor(Color("usDollarGreen"))
            .font(.caption)
            
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var interview = Interview.sampleData[0]
    static var previews: some View {
        CardView(interview: FetchedInterviewModel.sampleData)
            //.previewLayout(.fixed(width: 400, height: 60))
    }
}
