//
//  AddInterviewView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/1/23.
//

import SwiftUI
import Combine

// Define a struct to match the structure of each object in the JSON array
struct CompanyData: Decodable {
    let name: String
    let domain: String
    let logo: String
}

class ClearbitViewDataManager {
    
    func decodeData(_ data: Data) -> [CompanyData]? {
        let decoder = JSONDecoder()
        do {
            let companies = try decoder.decode([CompanyData].self, from: data)
            return companies
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }

    
    func constructURL(withQuery query: String) -> URL? {
        var components = URLComponents(string: "https://autocomplete.clearbit.com/v1/companies/suggest")
        components?.queryItems = [URLQueryItem(name: "query", value: query)]
        return components?.url
    }
    

    func downloadCompaniesDataAsync(query: String) async throws -> [CompanyData]? {
        
        guard let url = constructURL(withQuery: query) else {
            return nil
        }
        
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            print("decodeData(data): \(decodeData(data))")
            return decodeData(data)
        } catch {
            throw error
        }
    }
}

class ClearbitViewModel: ObservableObject {
    @Published var companyList: [DropdownMenuCompanyOption]? = nil
    
    let manager = ClearbitViewDataManager()
    
    func fetchCompaniesData(startwith query: String) async -> () {
        let data = try? await manager.downloadCompaniesDataAsync(query: "app")
        //TODO
        
        if let data = data {
            let transformData = data.map { companyData in
                DropdownMenuCompanyOption(name: companyData.name, icon: companyData.logo)
            }
            self.companyList = transformData
        }
    }
}

struct LogoView: View {
    
    let url: String
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            // Image successfully loaded
            image
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)  // Adjust size to match typical system image icon size
                .clipShape(Circle())  // Clip image to a circle shape
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))  // Optional: Add border
        } placeholder: {
            // Placeholder while loading
            ProgressView()
                .frame(width: 100, height: 100)
        }
    }
}


struct BasicFields: View {

    @ObservedObject var sharedData: InterviewSharedData
    
    @StateObject var model = ClearbitViewModel()
    
    @State private var showDropdown = false
    
    let debouncer = Debouncer(delay: 1)
    
    var body: some View {
        Section("Basic information") {
            VStack {
                DropdownMenu(
                    options: model.companyList,
                    dropDownLabel: "Select company",
                    sharedData: sharedData
                ) { value in
                    debouncer.debounce {
                        Task {
                            await model.fetchCompaniesData(startwith: value)
                        }
                    }
                }
                .zIndex(1)  // This will ensure the DropdownMenu appears on top of other views
                
//                LabeledContent("Company *") {
//                    TextField("company name", text: $sharedData.companyName)
//                        .autocapitalization(.none)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .border(.tertiary)
//                        .onTapGesture {
//                            showDropdown.toggle()  // Toggle dropdown visibility when TextField is tapped
//                        }
//                        .onChange(of: sharedData.companyName) { newValue in
//                            debouncer.debounce {
//                                Task {
//                                    await model.fetchCompaniesData(startwith: newValue)
//                                }
//                            }
//                            showDropdown = true  // Show dropdown when text changes
//                        }
//                }
                
//                if showDropdown {
//                    ScrollView {
//                        LazyVStack {
//                            ForEach(model.companyList ?? [], id: \.domain) { company in
//                                HStack(spacing: 5) {
//                                    Spacer()
//                                    LogoView(url: company.logo)
//                                    Text(company.name)
//                                        .font(.caption)
//                                        .padding()
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        //.background(Color.white)
//                                        .onTapGesture {
//                                            sharedData.companyName = company.name
//                                            showDropdown = false  // Hide dropdown when an item is selected
//                                        }
//                                    Spacer()
//                                }
//                            }
//                        }
//                    }
//                    .frame(maxHeight: 200)
//                    .frame(width: 200)
//                    .background(BlurView(style: .systemChromeMaterial))
//                    .border(Color.gray, width: 1)
//                }
                
                LabeledContent("Job title *") {
                    TextField("ex: Software Engineer", text: $sharedData.jobTitle)
                        .autocapitalization(.allCharacters)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .border(.tertiary)
                }
                
                DatePicker("Start Date *", selection: $sharedData.startDate, displayedComponents: [.date])
            }
        }
    }
}



struct BasicFields_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            BasicFields(sharedData: InterviewSharedData())
        }
       
//        BasicFields(companyName: $companyName, jobTitle: $jobTitle, startDate: $startDate)
    }
}
