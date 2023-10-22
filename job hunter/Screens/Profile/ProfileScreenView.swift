//
//  ProfileScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/22/23.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil

    func loadCurrentUser() async throws {
        let authResult = try AuthenticationManager.sharedAuth.getAuthenticatedUser()
        let result = try await UserManager.shared.getUser(userId: authResult.uid)
        self.user = result
    }
}

struct ProfileScreenView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {

        VStack {
            List {
                if let user = viewModel.user {
                    Text("user id: \(user.userId)")
                    if let dateCreated = user.dateCreated {
                        Text(DateFormatter().string(from: dateCreated))
                    }
                    if let email = user.email {
                        Text(email)
                    }

                }
            }
            SignOutView()
        }
        .task {
            do {
                try await viewModel.loadCurrentUser()
            } catch {
                print("loadCurrentUser error: \(error)")
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {

                } label: {
                    Image(systemName: "gear")
                        .font(.title2)
                }
            }
        }

    }
}

struct ProfileScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileScreenView()
                .environmentObject(AuthenticationModel())
        }
    }
}
