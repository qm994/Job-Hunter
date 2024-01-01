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
    @EnvironmentObject var interviewsViewModel: InterviewsViewModel
    
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    
    var body: some View {
        DebugView("interviewsViewModel.interviews is \(interviewsViewModel.interviews)")
        VStack {
            if interviewsViewModel.interviews.isEmpty {
                VStack {
                    Spacer()
                    Text("No Interviews Available. Add it through bottom plus button.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            } else if interviewsViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))
            } else {
                List(interviewsViewModel.interviews, id: \.id) { interview in
                    CardView(interviewsViewModel: interviewsViewModel, interview: interview)
                    
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
        .onChange(of: interviewsViewModel.error) { _, newValue in
            if let error = newValue {
                errorMessage = error
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK")) {
                    // Reset the error when the alert is dismissed
                    interviewsViewModel.error = nil
                }
            )
        }
        
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        let interviewsViewModel = InterviewsViewModel()
       
        NavigationStack {
            HomeScreenView()
                .environmentObject(AuthenticationModel())
                .environmentObject(InterviewsViewModel())
        }
    }
}
