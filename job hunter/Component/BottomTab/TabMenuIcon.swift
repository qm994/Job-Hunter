//
//  TabMenuIcon.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/4/23.
//

import SwiftUI

struct TabMenuIcon: View {
    @Binding var showMenu: Bool
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .shadow(radius: 4)
            
            Image(systemName: showMenu ? "xmark.circle.fill" : "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(Color(.systemBlue))
                .rotationEffect(Angle(degrees: showMenu ? 90 : 0))
            
        }
        .offset(y: -44)
    }
}

struct TabMenuIcon_Previews: PreviewProvider {
    @State static var showMenu = false
    static var previews: some View {
        TabMenuIcon(showMenu: $showMenu)
    }
}
