//
//  VisaSectionView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/10/23.
//

import SwiftUI

struct VisaSectionView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Text("OPT Sponsor")
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                HStack {
                    Text("CPT Sponsor")
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                HStack {
                    Text("H1B Sponsor")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                HStack {
                    Text("EB1 Sponsor")
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                HStack {
                    Text("EB2 Sponsor")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            } header: {
                Text("Visa Sponsor Options")
            }
        }
        .listStyle(.sidebar)
        .frame( width: 200, height: 200)
        .background(BlurView(style: .systemThickMaterialDark))
    }
}


struct VisaSectionView_Previews: PreviewProvider {
    static var previews: some View {
        VisaSectionView()
    }
}
