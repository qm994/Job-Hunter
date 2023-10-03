//
//  CustomTabView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/3/23.
//

import SwiftUI

let images = ["house.fill", "plus.circle.fill", "person.crop.circle"]

struct CustomTabView: View {
    @State private var selectedTab = "house.fill"
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $selectedTab) {
                HomeScreenView()
                    .tag("house.fill")
                
                AddInterviewView()
                    .tag("plus.circle.fill")
                
                ProfileScreenView()
                    .tag("person.crop.circle")
                
            } //TabView ends
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .ignoresSafeArea(.all, edges: .bottom)
            
            //MARK: TabView bottom tab buttons
            HStack {
                ForEach(images, id: \.self) {image in
                    TabButtonView(imageName: image, selectedTab: $selectedTab)
                    if (image != images.last) {
                        Spacer()
                    }
                }
            }// Bottom buttons Ends
            .frame(height: 40)
            .padding(.horizontal, 30)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(.horizontal)
            
        }
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
