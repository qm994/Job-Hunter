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
        VStack {
            if interviewsViewModel.interviews.isEmpty {
                Text("No Interviews Available. Add it through bottom plus button.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
            } else if interviewsViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))
            } else if let error = interviewsViewModel.error {
                Text("Failed to load interviews: \(error.localizedDescription)")
                    .foregroundColor(.red)
                // Add more UI customization as needed
            } else {
                List(interviewsViewModel.interviews, id: \.id) { interview in
                    CardView(interview: interview)
                    
                }
                .listStyle(.plain)
            }
        }
        // TODO: HANDLE ERROR
        .onAppear {
            Task {
                try await authModel.loadCurrentUser()
                try await interviewsViewModel.fetchInterviewsData()

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
