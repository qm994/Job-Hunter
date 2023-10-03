//
//  CardView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/25/23.
//

import SwiftUI

struct CardView: View {
    
    //MARK: PROPERTIES
    
    @State var companyName: String
    @State var jobTitle: String
    @State var currentStatus: String
    @State var isRejected: Bool
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
        }
        .frame(width: 200)
        .padding()
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            companyName: "Google",
            jobTitle: "Software Engineer 3",
            currentStatus: "Rejected",
            isRejected: true
        )
    }
}
