//
//  ClearbitViewModel.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/15/23.
//

import Combine
import SwiftUI

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
