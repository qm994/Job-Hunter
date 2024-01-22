//
//  CoreModel.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/11/23.
//

import Foundation


class CoreModel: ObservableObject {
    @Published var selectedTab: BottomNavigationModel = .home
    @Published var path: [String] = []
    @Published var editInterview: FetchedInterviewModel?
    
    @Published var addButtonStatus: String = "enabled"
    
    var interviewsViewModel: InterviewsViewModel?
    func setInterviewsViewModel(_ viewModel: InterviewsViewModel) {
        self.interviewsViewModel = viewModel
    }
    
    func triggerInterviewsUpdate() async throws {
        // After adding the interview, refresh the interview list
        try await interviewsViewModel?.fetchInterviewsData()
    }
}
