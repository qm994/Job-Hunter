//
//  DownloadImagesAsync.swift
//  job hunter
//
//  Created by Qingyuan Ma on 10/13/23.
//

import SwiftUI


class DownloadImagesAsyncManager {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            // Conditionally downcase: as?
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    //Function types cannot have argument labels; use '_' before 'error'
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
        

    
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
}

class DownloadImagesAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let manager = DownloadImagesAsyncManager()
//    func fetchImage() {
//        manager.downloadWithEscaping { [weak self] image, error in
//
//            DispatchQueue.main.async {
//                if let image = image {
//                    self?.image = image
//                }
//            }
//        }
//    }
    
    func fetchImage() async {
        let image = try? await manager.downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
    
}

struct DownloadImagesAsync: View {
    @StateObject private var viewModel  = DownloadImagesAsyncViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchImage()
            }
        }
    }
}

struct DownloadImagesAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImagesAsync()
    }
}
