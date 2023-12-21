//
//  VisaSponsorSection.swift
//  job hunter
//
//  Created by Qingyuan Ma on 11/19/23.
//

import SwiftUI

let VisaTypeNames: [String] = [
    "H-1B Visa",
    "L-1 Visa",
    "E-2 Visa",
    "O-1 Visa",
    "TN Visa",
    "J-1 Visa",
    "H-2B Visa",
    "EB-1 Visa",
    "EB-2 Visa",
    "EB-3 Visa",
    "E-1 Visa",
    "H-1B1 Visa",
    "E-3 Visa"
]

struct VisaSponsorSection: View {
    @State private var showSheet: Bool = false
    @EnvironmentObject var addInterviewModel: AddInterviewModel
    var body: some View {
        VStack {
            HStack {
                Text("Visa Sponsorship")
                    .fontWeight(.bold)
                
                Spacer()
                
                /// Button to open the sheet
                Button {
                   showSheet = true
                } label: {
                    Image(
                        systemName: showSheet ?
                        "arrow.down.right.and.arrow.up.left"
                        :"arrow.up.left.and.arrow.down.right"
                    )
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
            // Selected visa
            if let requiredVisa = addInterviewModel.requiredVisa {
                Text(requiredVisa)
                    .foregroundColor(.green)
                    .font(.headline)
            }
            
        }
        
        .sheet(isPresented: $showSheet) {
            VisaSponsorSelectionsSheet(showSheet: $showSheet)
                .presentationDetents([.medium, .large])
                .presentationBackground(.thinMaterial)
                .presentationDragIndicator(.visible)
                .presentationContentInteraction(.scrolls)
                .presentationCornerRadius(50)
        }
    }
}

struct VisaSponsorSelectionsSheet: View {
    @Binding var showSheet: Bool
    @EnvironmentObject var addInterviewModel: AddInterviewModel
    var body: some View {
        ScrollView {
            Text("Please select the visa you need and the company can sponsor")
                .font(.headline)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                .foregroundColor(.yellow)
                .padding(.all, 10)
            Spacer()
            VStack {
                ForEach(VisaTypeNames, id: \.self) {name in
                    Button{
                        withAnimation {
                            showSheet = false
                            addInterviewModel.requiredVisa = name
                        }
                    } label: {
                        HStack {
                            Text(name)
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "plus.app.fill")
                        }
                        .foregroundStyle(.black)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGreen))
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(.top, 50)
    }
}

#Preview {
    VisaSponsorSection()
        .environmentObject(AddInterviewModel())
}
