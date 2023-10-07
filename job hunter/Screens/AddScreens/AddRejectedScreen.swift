//
//  AddRejectedScreen.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/5/23.
//

import SwiftUI

struct AddRejectedScreen: View {
    var body: some View {
        NavigationView {
            AddInterviewView()
                .navigationBarTitle("Rejected Interview", displayMode: .inline)
                .navigationBarItems(
                    leading:Button("Cancel") {
                        print("close sheet!")
                    },
                    trailing: Button("Add") {
                        print("add the item!")
                    }
                )
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct AddRejectedScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddRejectedScreen()
    }
}
