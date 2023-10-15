//
//  VisualEffectView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/15/23.
//

import SwiftUI

///frosted glass effect
///UIViewRepresentable is a protocol that a SwiftUI view can conform to when it needs to represent a UIKit view.
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}


#Preview {
    VisualEffectView(effect: UIBlurEffect(style: .regular))
}
