//
//  CompaniesListScreenView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 1/17/24.
//

import SwiftUI

//TODO: Maybe refactor how interviewsDidChange publisher works and currently
// all child views have to use the onReceive for state changes. Tricky for an array of struct type especially when one of the struct property changes

class CompaniesListModel: ObservableObject {
    @Published var expandedSections: Set<String> = []
    
    func toggleSection(name: String) {
        if expandedSections.contains(name) {
            expandedSections.remove(name)
        } else {
            expandedSections.insert(name)
        }
    }
    
    func collapseAll() {
        expandedSections.removeAll()
    }
    
    func expandAll(names: [String]) {
        expandedSections = expandedSections.union(names)
    }
}


struct CompaniesListScreenView: View {
    
    @StateObject var companiesListModel = CompaniesListModel()
    @EnvironmentObject var interviewsModel: InterviewsViewModel
    @EnvironmentObject var coreModel: CoreModel
    
    @State private var updateTrigger = UUID()

    
    var interviewsByCompany: [String: [FetchedInterviewModel]] {
        
        Dictionary(grouping: interviewsModel.interviews, by: { $0.company.name })
    }
    
    var body: some View {
        
        DebugView("interviewsModel updated: \(interviewsModel.interviews.first { $0.company.name == "Google" }?.favorite)")
        DebugView("interviewsByCompany: \(interviewsByCompany["Google"]?.first?.favorite )")
        VStack {
            HStack {
                Button {
                    withAnimation {
                        companiesListModel.collapseAll()
                    }
                } label: {
                    Text("Close All")
                }
                .buttonStyle(.borderedProminent)
                .disabled(interviewsByCompany.keys.count == 0)
                
                Button {
                    withAnimation {
                        companiesListModel.expandAll(names: Array(interviewsByCompany.keys))
                    }
                } label: {
                    Text("Expand All")
                }
                .buttonStyle(.borderedProminent)
                .disabled(interviewsByCompany.keys.count == 0)
            }
            Group {
                if interviewsByCompany.keys.count == 0 {
                   
                    Button {
                        withAnimation {
                            coreModel.path.append(NavigationPath.addInterviewScreen.rawValue)
                        }
                    } label: {
                        Text("Add interview with company here!")
                            .fontWeight(.heavy)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .white,
                                        .teal
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(
                                color: .black.opacity(0.25),
                                radius: 0.25,
                                x: 1,
                                y: 2
                            )
                    }
                    .buttonStyle(.borderedProminent)
                    .contentShape(Circle())
                    .padding()
                    .scaleEffect(1.2)
                }
            }
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 30) {
                    ForEach(interviewsByCompany.keys.sorted(), id: \.self) { companyName in
                        CompanyListSection(
                            companyName: companyName,
                            interviews: interviewsModel.interviews.filter {
                                $0.company.name == companyName
                            }
                                //interviewsByCompany[companyName] ?? []
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .environmentObject(companiesListModel)
       
    }
}

struct CompanyListSection: View {
    
    @EnvironmentObject var interviewsModel: InterviewsViewModel
    @EnvironmentObject var companiesListModel: CompaniesListModel
    
    let companyName: String
    let interviews: [FetchedInterviewModel]
    
    @State private var updateTrigger = UUID()

    var body: some View {
        DebugView("CompanyListSection: \(interviews[0].company.name) - \(interviews[0].favorite)")
        Group {
            if companiesListModel.expandedSections.contains(companyName) {
                VStack {
                    HStack {
                        AsyncImageView(url: interviews.first?.company.logo ?? "") {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50, alignment: .leading)
                        Text(companyName)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(interviews.count)")
                            .font(.title3)
                    }
                    .contentShape(Rectangle())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .onTapGesture {
                        withAnimation {
                            companiesListModel.toggleSection(name: companyName)
                        }
                    }
                    
                    InterviewCardsListView(interviews: interviews, companyName: companyName)
                        
                }
                .onReceive(interviewsModel.interviewsDidChange) {
                    updateTrigger = UUID()
                }
            } else {
                ZStack {
                    VStack {}
                        .contentShape(Rectangle())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("lightBlue"))
                        .cornerRadius(20)
                        .offset(y:30)
                    
                    HStack {
                        AsyncImageView(url: interviews.first?.company.logo ?? "") {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50, alignment: .leading)
                        Text(companyName)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(interviews.count)")
                            .font(.title3)
                    }
                    .contentShape(Rectangle())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .onTapGesture {
                        withAnimation {
                            companiesListModel.toggleSection(name: companyName)
                        }
                    }
                }
            }
        }// group ends
    }
}

struct InterviewCardsListView: View {
    let interviews: [FetchedInterviewModel]
    let companyName: String
    @EnvironmentObject var companiesListModel: CompaniesListModel
    @EnvironmentObject var interviewsModel: InterviewsViewModel
    
    @State private var updateTrigger = UUID()

    var body: some View {
        DebugView("InterviewCardsListView Redraw")
        VStack() {
            ForEach(interviews, id: \.self.id) { interview in
                InterviewCardView(interview: interview)
            }
        }
        .contentShape(Rectangle())
        .padding()
        .frame(maxWidth: .infinity)
        .background(companiesListModel.expandedSections.contains(companyName) ? Color.black : Color("lightBlue"))
        .cornerRadius(20)
        .offset(y:10)
        .onReceive(interviewsModel.interviewsDidChange) {
            updateTrigger = UUID()
        }
    }
}

// Define a new view for the interview card
struct InterviewCardView: View {
    let interview: FetchedInterviewModel
    
    @EnvironmentObject var companiesListModel: CompaniesListModel
    @EnvironmentObject var interviewsModel: InterviewsViewModel
        
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        DebugView("InterviewCardView updated:\(interview.company.name) -  \(interview.favorite)")
        HStack(alignment: .center, spacing: 10) {
            Button {
                Task {
                    do {
                        try await interviewsModel.toggleFavorite(interviewId: interview.id)
                    
                    } catch {
                        print("Failed to toggle favorite status: \(error)")
                    }
                }
            } label: {
                Image(systemName: interview.favorite ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(interview.favorite ? .yellow : .black)
                    
            }
            .buttonStyle(.plain)
            
            Spacer()
            VStack(alignment: .leading, spacing: 3) {
                Text(interview.status)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Applied on \(dateFormatter.string(from: interview.startDate))")
                    .font(.system(size: 15, weight: .regular, design: .monospaced))

                Text(interview.jobTitle)
                    .font(.system(size: 15, weight: .regular, design: .monospaced))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .shadow(radius: 5)
       
    }
}


#Preview {
    CompaniesListScreenView()
        .environmentObject(InterviewsViewModel())
}
