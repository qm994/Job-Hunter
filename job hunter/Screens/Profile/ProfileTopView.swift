//
//  ProfileTopView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 12/20/23.
//

import SwiftUI
import PhotosUI

struct ProfileTopView: View {
    @EnvironmentObject var authModel: AuthenticationModel
    @EnvironmentObject var interviewsModel: InterviewsViewModel
    
    private var statusCounts: (pending: Int, rejected: Int, offer: Int, total: Int) {
        if interviewsModel.interviews.count == 0 {
            return (0, 0, 0, 0)
        }
        let pendingCount = interviewsModel.interviews.filter { $0.status == ApplicationStatus.pending.rawValue }.count
        let rejectedCount = interviewsModel.interviews.filter { $0.status == ApplicationStatus.rejected.rawValue }.count
        
        let offerCount = interviewsModel.interviews.filter { $0.status == ApplicationStatus.offer.rawValue }.count
        
        let total = pendingCount + rejectedCount + offerCount
        
        return (pendingCount, rejectedCount, offerCount, total)
    }
    
    
    let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(alignment: .center) {
                    ZStack {
                        ProfilePhotoView(
                            geometry: geometry
                        )
                        
                        ProfilePhotoPlusView(geometry: geometry)
                    } // ZStack ends
                    .padding([.top, .leading], 20)
                    
                    VStack(alignment: .leading) {
                        if let user = authModel.userProfile {
                            if let dateCreated = user.dateCreated {
                                Text("Joined on: \(dateFormatter.string(from: dateCreated))")
                            }
                            if let dateModified = user.dateModified {
                                Text("Last modified on: \(dateFormatter.string(from: dateModified))")
                            }
                            if let email = user.email {
                                Text("current email: \(email)")
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding([.top, .leading], 20)
                } // 1st hstack ends
                
                
                HStack {
                    let vStacks = [
                        StatusViewItem(count: statusCounts.pending, status: .pending),
                        StatusViewItem(count: statusCounts.rejected, status: .rejected),
                        StatusViewItem(count: statusCounts.offer, status: .offer),
                    ]


                    ForEach(vStacks) { item in
                        VStack(alignment: .leading) {
                            Text("\(item.count)")
                            Text(item.status.rawValue)
                                .foregroundColor(item.status.statusColor)
                        }
                        .padding(.horizontal)
                    }
                    VStack(alignment: .leading) {
                        Text("\(statusCounts.total)")
                        Text("Total").foregroundStyle(Color(.bubblegum))
                    }

                }
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height * 0.3)
                .background(BlurView(style: .systemThickMaterialDark))
                .cornerRadius(15)
                .padding()

                
            } // Vstack ends
        } // Geometry ends
        //.frame(height: geom)
        .overlay(Rectangle().stroke())
        .onAppear {
            Task {
                try await authModel.loadCurrentUser()
            }
        }
        
    }
}

struct StatusViewItem: Identifiable {
    let count: Int
    let status: ApplicationStatus
    var id: String { status.id }
}

struct ProfilePhotoView: View {
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    @State private var isUpdatingPhoto: Bool = false
    let geometry: GeometryProxy
    
    
    @EnvironmentObject var authModel: AuthenticationModel
    
    @State private var errorMessage: String? = nil
    @State private var showError: Bool = false
    
    var body: some View {
        
        PhotosPicker(selection: $avatarItem) {
            if isUpdatingPhoto {
                ProgressView()
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            } else {
                AsyncImageView(url: authModel.userProfile?.photoUrl ?? "", geometry: geometry) {
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.7)
                        .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                } // AsyncImageView ends
            }
        }
        .onChange(of: avatarItem) {
            self.errorMessage = nil
            self.showError = false
            self.isUpdatingPhoto = true // Start loading
            Task {
                if let imageData = try await avatarItem?.loadTransferable(type: Data.self) {
                    avatarImage = UIImage(data: imageData)
                    // TODO: Additional action, such as uploading avatarImage to a database
                    if let imageToUpload = avatarImage {
                        if let uploadData = imageToUpload.jpegData(compressionQuality: 0.9) {
                            // Upload 'uploadData' to Firebase Storage and FireStore user document
                            
                            do {
                                let url = try await authModel.uploadImageToFirebaseStorage(imageData: uploadData)
                                let urlString = try await authModel.updateUserPhotoURLInFirestore(photoURL: url)
                                authModel.userProfile?.photoUrl = urlString
                                print("URL updated successfully: \(urlString)")
                            } catch {
                                self.errorMessage = error.localizedDescription
                                self.showError = true
                            }
                            self.isUpdatingPhoto = false // Stop loading
                        }
                    }
                }
            }
        } // onChange ends
        .alert(isPresented: $showError, content: {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage ?? "Failed to update photo."),
                dismissButton: .default(Text("OK")))
        })
        
    }
}

struct ProfilePhotoPlusView: View {
    let geometry: GeometryProxy
    var body: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: geometry.size.width * 0.07, height: geometry.size.width * 0.07) // Adjust the size as needed
            .foregroundColor(Color.yellow)
            .background(.white)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 1)) // Add stroke if needed
            .offset(x: geometry.size.width * 0.08, y: geometry.size.width * 0.08) // Adjust the offset as needed
            .padding(.bottom, 8) // Adjust the padding to move the plus icon down
            .padding(.trailing, 8)
    }
}

#Preview {
    
    struct WrapperView: View {
        
        var body: some View {
            ProfileTopView()
                .environmentObject(AuthenticationModel())
                .environmentObject(InterviewsViewModel())
        }
    }
    
    return WrapperView()
    
}
