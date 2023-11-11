//
//  DebugView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/7/23.
//

import SwiftUI

struct DebugView: View {
    let message: String

    init(_ message: String) {
        self.message = message
        print("DebugView message: \(message)")
    }

    var body: some View {
        EmptyView()
    }
}
