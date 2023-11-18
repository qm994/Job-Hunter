//
//  CirclePlusAddButton.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/4/23.
//

import SwiftUI

struct CirclePlusAddButton: View {
    @State private var onTap = false
    /// closure which will be executed when button click/taped
    var onTapAction: () -> Void
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.black)
                .frame(width: 56, height: 56)
                .shadow(radius: 4)
                .background(.ultraThinMaterial, in: Circle())
                
            
            Image(systemName: onTap ? "xmark.circle.fill" : "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.blue.opacity(0.5))
                .background(.ultraThinMaterial, in: Circle())
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: onTap ? 90 : 0))
        }
        .onTapGesture {
            withAnimation {
                onTap.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { onTapAction() }
            }
        }
        .onAppear {
            onTap = false
        }
    }
}

struct CirclePlusAddButton_Previews: PreviewProvider {
    static var previews: some View {
        CirclePlusAddButton {
            
        }
    }
}
