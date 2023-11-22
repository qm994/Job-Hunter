//
//  HomeScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/24/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

// Singleton interface to control the creation of interview
final class InterviewsDataAccessManager {
    static let shared = InterviewsDataAccessManager()
    init(){}
    
    private let interviewCollection = Firestore.firestore().collection("interviews")
    
    
    func getAllInterviews(userId: String) {
        print(UserManager.shared.userDocument(userId: userId))
    }
    
}


struct HomeScreenView: View {
    
    @EnvironmentObject var authModel: AuthenticationModel
    
    var body: some View {
        DebugView("CURREN USER IS: \(authModel.userProfile)")
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            ScrollView {
                ForEach(Interview.sampleData, id: \.self.id) { interview in
                    CardView(interview: interview)
                }
            }
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
            .environmentObject(AuthenticationModel())
    }
}
