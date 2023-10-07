//
//  AddSucceedScreen.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/5/23.
//

import SwiftUI

struct AddSucceedScreen: View {
    var body: some View {
        NavigationView {
            AddInterviewView()
                .navigationBarTitle("Succeed Interview", displayMode: .inline)
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

struct AddSucceedScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddSucceedScreen()
    }
}
