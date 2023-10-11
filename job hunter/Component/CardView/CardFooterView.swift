//
//  CardFooterView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/10/23.
//

import SwiftUI

struct CardFooterView: View {
    var body: some View {
        //MARK: SECOND ROW
        HStack(alignment: .center, spacing: 10) {
            HStack {
                Text("Visa Sponsor")
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
            
            
            HStack {
                Text("Relocation Required")
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
            Spacer()
            
            Button {
                print("Action should open a menu to (1) delete the card (2) go to edit form")
            } label: {
                
                ZStack {
                    Rectangle()
                        .fill(Color.black)  // Add some color to see the rectangle
                        .frame(width: 20, height: 20)
                        .cornerRadius(8)   // Optional: Add some corner radius for better aesthetics
                    
                    Image(systemName: "ellipsis")
                        .scaledToFit()
                        .frame(height: 20)  // Control the image size
                        .foregroundColor(.white)
                }
                .contentShape(Rectangle())
            }
        }
        .font(.footnote)
    }
}

struct CardFooterView_Previews: PreviewProvider {
    static var previews: some View {
        CardFooterView()
    }
}
