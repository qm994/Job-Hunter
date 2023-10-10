//
//  CardView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/8/23.
//

import SwiftUI

struct CardView: View {
    let interview: Interview
    
    var totalExpected: String {
        let base = Double(interview.job.expectedSalary?.baseRange  ?? "0")
        let other = Double(interview.job.expectedSalary?.otherCompensation  ?? "0")
        let total = base! + other!
        return total == 0 ? "unknow" : String(total)
    }
    var body: some View {
        VStack(spacing: 20) {
            //MARK: FIRST ROW
            HStack(alignment: .top) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(interview.job.company.name)
                        .font(.headline)
                    
                    VStack(alignment: .leading) {
                        Label(interview.job.title, systemImage: "briefcase.circle")
                        Label(interview.job.location.rawValue, systemImage: "location.circle")
                        Label(formatDateWithoutTime(interview.job.apppliedDate), systemImage: "clock.badge.checkmark")
                    }
                    .font(.caption)
                }// First row 1ST VStack end
                
                Spacer()
                
                //MARK: 1ST ROW'S 2ND COL
                VStack(alignment: .leading, spacing: 10) {
                    //status
                    HStack(spacing: 5) {  // You can adjust the spacing value as per your need
                        HStack {
                            Image(systemName: interview.status.iconName)
                            Text("Status:")
                                
                        }
                        Text(interview.status.rawValue)
                    }
                    .foregroundColor(interview.status.textColor)
                    .font(.headline)
                    
                    VStack(alignment: .leading) {
                        // pay
                        HStack(spacing: 5) {  // You can adjust the spacing value as per your need
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                Text("Base expect range:")
                            }

                            Text(interview.job.expectedSalary?.baseRange  ?? "0")
                        }
                        .foregroundColor(Color("usDollarGreen"))
                        .font(.caption)
                        
                        // other comp
                        HStack(spacing: 5) {  // You can adjust the spacing value as per your need
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                Text("Other comp range:")
                            }

                            Text(interview.job.expectedSalary?.otherCompensation  ?? "unknow")
                        }
                        .foregroundColor(Color("usDollarGreen"))
                        .font(.caption)
                        
                        //TODO: SHOW THE Increase/Decrease percent compare with user's current TC
                        // total expec
                        HStack(spacing: 5) {  // You can adjust the spacing value as per your need
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                Text("Total expect:")
                            }

                            Text(totalExpected)
                        }
                        .foregroundColor(Color("usDollarGreen"))
                        .font(.caption)
                        
                    }
                } // First row 2nd VStack end
            } //FIRST ROW ENDS
            
            //MARK: SECOND ROW
            HStack(alignment: .center, spacing: 10) {
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
                Spacer()
                
                Button {
                    print("Action should open a menu to (1) delete the card (2) go to edit form")
                } label: {
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.gray)  // Add some color to see the rectangle
                            .frame(width: 20, height: 20)
                            .cornerRadius(8)   // Optional: Add some corner radius for better aesthetics
                        
                        Image(systemName: "ellipsis.rectangle")
                            .scaledToFit()
                            .frame(height: 20)  // Control the image size
                            .foregroundColor(.black)
                    }
                    .contentShape(Rectangle())
                }
            }
            .font(.footnote)
            
            
        }// Root VSTACK ENDS
        .padding()
        .background(BlurView(style: .systemThickMaterialDark))
        .cornerRadius(15)
        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct CardView_Previews: PreviewProvider {
    static var interview = Interview.sampleData[0]
    static var previews: some View {
        CardView(interview: interview)
            //.previewLayout(.fixed(width: 400, height: 60))
    }
}
