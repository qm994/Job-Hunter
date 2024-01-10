//
//  ProfileTopView.swift
//  job hunter
//
//  Created by Qingyuan Ma on 12/20/23.
//

import SwiftUI
import PhotosUI

struct StatusViewItem: Identifiable {
    let count: Int
    let status: ApplicationStatus
    // Compute property
    var id: String { status.id }
}

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
                HStack(alignment: .top) {
                    ZStack() {
                        ProfilePhotoView()
                           
                        ProfilePhotoPlusView()
                            .frame(width: geometry.size.width * 0.07, height: geometry.size.height * 0.1)
                            .offset(x: geometry.size.width * 0.08, y: geometry.size.height * 0.08)
                    } // ZStack ends
                    .padding([.top, .leading], 20)
                    .frame(width: geometry.size.width * 0.3, alignment: .leading)
                    //.overlay(Rectangle().stroke(Color.yellow))
                    
                    VStack(alignment: .leading) {
                        if let user = authModel.userProfile {
                            Text("\(user.userName)")
                                .font(.title)
                                .fontWeight(.heavy)
                            if let dateCreated = user.dateCreated {
                                Text("Joined on: \(dateFormatter.string(from: dateCreated))")
                                    .foregroundStyle(Color.gray)
                                    .fontWeight(.thin)
                                    
                            }
                            if let dateModified = user.dateModified {
                                Text("Modified on: \(dateFormatter.string(from: dateModified))")
                                    .foregroundStyle(Color.gray)
                                    .fontWeight(.thin)
                            }
                            if let email = user.email {
                                Text("\(email)")
                                    .lineLimit(1)
                                    .foregroundStyle(Color.gray)
                                    .fontWeight(.thin)
                            }
                        }
                    }
                    .padding()
                    .frame(width: geometry.size.width * 0.7, alignment: .leading)
                } // 1st hstack ends
                //.overlay(Rectangle().stroke(Color.red))
                
                //MARK: status counts
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
        .onAppear {
            Task {
                try await authModel.loadCurrentUser()
            }
        }
        
    }
}



struct ProfilePhotoView: View {
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    @State private var isUpdatingPhoto: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showError: Bool = false
    
    @EnvironmentObject var authModel: AuthenticationModel
    
    
    var body: some View {
        GeometryReader { geometry in
            PhotosPicker(selection: $avatarItem) {
                Group {
                    if isUpdatingPhoto {
                        ProgressView()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    } else {
                        AsyncImageView(url: authModel.userProfile?.photoUrl ?? "", geometry: geometry) {
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                        }
                        .scaleEffect(1.2)
                    } // AsyncImageView ends
                } // Group
                .frame(width: geometry.size.width, height: geometry.size.height)
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
}

struct ProfilePhotoPlusView: View {
    var body: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.yellow)
            .background(.black)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
    }
}

#Preview {
    
    struct WrapperView: View {
        
        var body: some View {
            GeometryReader { geometry in
                ProfileTopView()
                    .environmentObject(AuthenticationModel())
                    .environmentObject(InterviewsViewModel())
                    .frame(height: geometry.size.height * 0.3)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            
        }
    }
    
    return WrapperView()
    
}
