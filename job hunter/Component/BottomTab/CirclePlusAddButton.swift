//
//  CirclePlusAddButton.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/4/23.
//

import SwiftUI

struct CirclePlusAddButton: View {
    
    @EnvironmentObject var coreModel: CoreModel
    @State private var onTap = false
    @State private var showWarning = false // State to control tooltip visibility
    /// Closure which will be executed when button clicked/tapped
    var onTapAction: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Circle()
                .foregroundColor(coreModel.addButtonStatus == "disabled" ? .gray : .black)
                .frame(width: 52, height: 52)
                .shadow(radius: 4)
                .background(.ultraThinMaterial, in: Circle())

            Image(systemName: onTap ? "xmark.circle.fill" : "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(.ultraThinMaterial, in: Circle())
                .foregroundColor(coreModel.addButtonStatus == "disabled" ? .gray : Color.blue.opacity(0.5))
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: onTap ? 90 : 0))
                .onTapGesture {
                    if coreModel.addButtonStatus == "disabled" {
                        showWarning.toggle() // Toggle tooltip visibility
                    } else {
                        onTap.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { onTapAction() }
                    }
                }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .onAppear {
            onTap = false
            showWarning = false
        }
        .alert(isPresented: $showWarning) {
            Alert(
                title: Text(LocalizedStringKey("Not Support!")),
                message:  Text(LocalizedStringKey("For cost reasons, we can only support user add at most 5 interviews. Once we figure out the cost, more spaces will be available. Stay tuned!")),
                dismissButton: .default(Text(LocalizedStringKey("OK")))
            )
        }
    }
}

struct TooltipView: View {
    var text: String
   

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(10)
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(5)
            .transition(.opacity)
            .frame(maxWidth: .infinity)
    }
}

struct CirclePlusAddButton_Previews: PreviewProvider {
    //@State var coreModel: CoreModel = CoreModel()
    static var previews: some View {
        CirclePlusAddButton() {
            
        }
        .environmentObject(CoreModel())
        
    }
}
