//
//  AddBaby.swift
//  Babylo
//
//  Created by Babylo  on 6/4/2023.
//

import SwiftUI

struct AddBaby: View {

    @State private var babyName = ""

    @State private var selectedDate = Date()

    @State private var selectedImage: UIImage?

    @State private var showGallery = false

    

    



    var body: some View {

        VStack(spacing: 20){

            Button(action:{showGallery = true}){

                ZStack {

                                    Circle()

                                        .fill(Color.gray.opacity(0.1))

                                        .frame(width: 150, height: 150)

                    if let image = selectedImage{

                        Image(uiImage: image)

                            .resizable()

                            .scaledToFit()

                    }else{

                        Image(systemName: "plus")

                            .font(.system(size: 70))

                            .foregroundColor(.yellow)

                    }

                                    

                                }

            }

            TextField("Baby name", text: $babyName).padding(.horizontal,20).padding(.vertical,10)

                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.yellow).padding(.horizontal,8))

            

            DatePicker("Select baby birthday", selection: $selectedDate, displayedComponents: .date).padding(.horizontal,20)

            

            Button("Add Baby", action: {})

                .frame(width: 100)

                .padding()

                .foregroundColor(.white)

                .background(Color.yellow)

                .cornerRadius(10)

                            

        }

        .padding()

        .sheet(isPresented: $showGallery){

            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)

        }

    }

}



struct AddBaby_Previews: PreviewProvider {

    static var previews: some View {

        AddBaby()

    }

}



struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode

    @Binding var selectedImage: UIImage?

    var sourceType: UIImagePickerController.SourceType

    

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePickerController = UIImagePickerController()

        imagePickerController.delegate = context.coordinator

        imagePickerController.sourceType = sourceType

        return imagePickerController

    }

    

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

        

    }

    

    func makeCoordinator() -> Coordinator {

        Coordinator(self)

    }

    

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        let parent: ImagePicker

        

        init(_ parent: ImagePicker) {

            self.parent = parent

        }

        

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let selectedImageFromPicker = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

                parent.selectedImage = selectedImageFromPicker

            }

            parent.presentationMode.wrappedValue.dismiss()

        }

        

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

            parent.presentationMode.wrappedValue.dismiss()

        }

    }

}


