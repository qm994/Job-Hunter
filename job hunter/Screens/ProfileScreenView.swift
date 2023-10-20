//
//  ProfileScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/3/23.
//

import SwiftUI

struct ProfileScreenView: View {
    var body: some View {
        SignOutView()
    }
}

struct ProfileScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreenView()
            .environmentObject(AuthenticationModel())
    }
}
