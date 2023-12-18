//
//  HomeScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/24/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct HomeScreenView: View {
    
    @EnvironmentObject var authModel: AuthenticationModel
    @StateObject var interviewsViewModel: InterviewsViewModel = InterviewsViewModel()
    
    
    var body: some View {
        
//        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(interviewsViewModel.interviews, id: \.self.id) { interview in
                        CardView(interview: interview)
                    }
                }
                .padding(.top)
            }
            
        //}
        .padding(.bottom, UIScreen.main.bounds.height / 10)
        
        .onAppear {
            Task {
                try await authModel.loadCurrentUser()
                try await interviewsViewModel.fetchInterviews()
                
            }
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let interviewsViewModel = InterviewsViewModel()
        NavigationStack {
            HomeScreenView(interviewsViewModel: interviewsViewModel)
                .environmentObject(AuthenticationModel())
        }
    }
}
