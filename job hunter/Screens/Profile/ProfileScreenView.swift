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
        let dbUser = try await UserManager.shared.getUser(userId: authResult.uid)
        //try AuthenticationManager.sharedAuth.signOutUser()
        self.user = dbUser
    }
}

struct ProfileScreenView: View {

    @EnvironmentObject var authModel: AuthenticationModel

    var body: some View {
        VStack {
            SignOutView()
            List {
                if let user = authModel.userProfile {
                    Text("user id: \(user.userId)")
                    if let dateCreated = user.dateCreated {
                        Text(DateFormatter().string(from: dateCreated))
                    }
                    if let email = user.email {
                        Text(email)
                    }
                }
            }
        }
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
