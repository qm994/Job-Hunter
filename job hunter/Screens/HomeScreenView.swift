//
//  HomeScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/24/23.
//

import SwiftUI


struct HomeScreenView: View {
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            ScrollView {
                ForEach(Interview.sampleData, id: \.self.id) { interview in
                    CardView(interview: interview)
                }
            }
            
            //Text("hellow")
            //MARK: Bottom Navigation
            //BottomNavigationView()
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
