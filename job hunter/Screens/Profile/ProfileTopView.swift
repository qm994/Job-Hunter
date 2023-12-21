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
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    
    let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        DebugView("\(authModel.userProfile)")
        GeometryReader { geometry in
            HStack(alignment: .center) {
                VStack {
             
                    AsyncImageView(url: authModel.userProfile?.photoUrl ?? "") {
                        //photoUrl exists but failed to load
                        if let photoUrl = authModel.userProfile?.photoUrl {
                            Image(systemName: "person.fill.xmark")
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(0.70, contentMode: .fit)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        } else {
                            ProfilePhotoUploadButton(
                                geometry: geometry,
                                avatarItem: $avatarItem,
                                avatarImage: $avatarImage
                            )
                        }
                    } // AsyncImageView ends
                } // first VStack ends
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
                .padding([.top, .leading], 20)}
        } // Geometry ends
        .onAppear {
            Task {
                try await authModel.loadCurrentUser()
            }
        }
        
    }
}

struct ProfilePhotoUploadButton: View {
    let geometry: GeometryProxy
    @Binding var avatarItem: PhotosPickerItem?
    @Binding var avatarImage: UIImage?
    var body: some View {
        DebugView("ProfilePhotoUploadButton")
        
        PhotosPicker(selection: $avatarItem) {
            ZStack {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(0.70, contentMode: .fit)
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                    .clipShape(Circle())
                    .foregroundColor(Color.white)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                
                
                ProfilePhotoPlusView(geometry: geometry)
            }
        }
        .onChange(of: avatarItem) {
            Task {
                if let imageData = try await avatarItem?.loadTransferable(type: Data.self) {
                    avatarImage = UIImage(data: imageData)
                    // TODO: Additional action, such as uploading avatarImage to a database
                    if let imageToUpload = avatarImage {
                        if let uploadData = imageToUpload.jpegData(compressionQuality: 0.9) {
                            // Upload 'uploadData' to Firebase Storage
                            print("uploadData: \(uploadData)")
                        }
                    }
                } else {
                    print("Failed")
                }
            }
        }
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
        }
    }
    
    return WrapperView()
    
}
