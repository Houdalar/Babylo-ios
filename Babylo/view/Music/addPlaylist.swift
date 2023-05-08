//
//  addPlaylist.swift
//  Babylo
//
//  Created by houda lariani on 26/4/2023.
//

import SwiftUI
import PhotosUI

struct AddPlaylistView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var backendService: MusicViewModel
    @State private var playlistName: String = ""
    @State private var coverImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @State private var isLoading = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(alignment: .center) {
            if let image = coverImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 280, height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 20)) 
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            } else {
                VStack(alignment: .center) {
                    Text("Upload Photo")
                        .font(.title)
                        .foregroundColor(.white)
                    Image(systemName: "arrow.up.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                .frame(width: 280, height: 280)
                .background(Color(.systemGray5))
                .cornerRadius(20)
                .onTapGesture {
                    isImagePickerPresented = true
                }
            }
            TextField("Playlist Name", text: $playlistName)
                .frame(height: 50)
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 15))
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color(.systemGray6).opacity(0.7))
                .cornerRadius(30)
                .padding(.horizontal,20)
                .padding(.top,40)

            Button(
                action: {
                    if let image = coverImage {
                        isLoading = true
                        backendService.addPlaylist(name: playlistName, cover: image) { success in
                            isLoading = false
                            if success {
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                errorMessage = "Failed to create the playlist. Please try again."
                                showErrorAlert = true
                            }
                        }
                    } else {
                        errorMessage = "Cover image is required."
                        showErrorAlert = true
                    }
                }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                        .scaleEffect(2)
                        .padding()
                } else {
                    Text("Create")
                        .padding(.horizontal,110)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(30)
                        .frame(maxWidth: .infinity)
                }
            }
                .padding(.horizontal, 20)
                .padding(.top, 40)

          
        }
        .sheet(isPresented: $isImagePickerPresented, content: {
            PhotosUIImagePicker(selectedImage: $coverImage)
        })
    }
}



struct addPlaylist_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaylistView()
    }
}

struct PhotosUIImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotosUIImagePicker

        init(_ parent: PhotosUIImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let itemProvider = results.first?.itemProvider,
               itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self?.parent.selectedImage = image
                        }
                        self?.parent.presentationMode.wrappedValue.dismiss()
                    }
                }
            } else {
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
