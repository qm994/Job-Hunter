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
        VStack {
            if interviewsViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))
            } 
            else if interviewsViewModel.interviews.isEmpty {
                VStack {
                    Spacer()
                    Text("No Interviews Available. Add it through bottom plus button.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
            else {
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
        .onChange(of: interviewsViewModel.error) { newValue in
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
        
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Welcome back: ")
                            .foregroundColor(.secondary) // Less prominent
                            .blur(radius: 0.5)
                            .font(.title2)
                        
                        Text("\(authModel.userProfile?.userName ?? "unknown")")
                            .fontWeight(.bold) // Highlighted part
                            .foregroundColor(.yellow)
                        
                    }
                    HStack {
                        Text("Total ")
                            .foregroundColor(.secondary) // Less prominent
                            .blur(radius: 0.5)
                        Text("\(interviewsViewModel.interviews.count)")
                            .fontWeight(.bold) // Highlighted part
                            .foregroundColor(.primary)
                        Text(" interviews on track")
                            .foregroundColor(.secondary) // Less prominent
                            .blur(radius: 0.5)
                    }
                } // vstack ends
                
            } // ToolbarItem end
        } //toolbar ends
        .toolbarColorScheme(.dark)
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NavigationStack {
            HomeScreenView()
                .environmentObject(AuthenticationModel())
                .environmentObject(InterviewsViewModel())
        }
    }
}
