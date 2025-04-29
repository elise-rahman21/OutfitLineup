//
//  ContentView.swift
//  OutfitLineup
//
//  Created by Rahman, Elise (513171) on 4/29/25.
//

import SwiftUI

struct ContentView: View {
    
    // Stores the categories (ClothesGroup) and the clothing items within them
    @State var clothesGroups = [
        ClothesGroup(id: 0, category: "Tops", clothings: []), //tops
        ClothesGroup(id: 1, category: "Bottoms", clothings: []), //bottoms
        ClothesGroup(id: 2, category: "Accessories", clothings: []), //accessory
        ClothesGroup(id: 3, category: "Shoes", clothings: []) //shoes
    ]
    
    @State private var isCameraActive = false // Controls if the camera is active
    @State private var capturedImage: UIImage? = nil // Stores the captured image
    @State private var isCategorySelectionActive = false // Controls if the category selection pop-up is active
    
    
    var body: some View {
        Button(action: {
            // Action to open the digital closet
        }) {
            Image("closet") // <-- your own asset image
                .resizable()
                .frame(width: 40, height: 40) // size of the button
                .aspectRatio(contentMode: .fit)
        }
        .padding()
        NavigationView {
              VStack {
                  if capturedImage == nil {
                      // Show "+" button if no image captured
                      Button(action: {
                          isCameraActive = true
                      }) {
                          Image(systemName: "plus.circle")
                              .resizable()
                              .frame(width: 60, height: 60)
                              .foregroundColor(.cyan)
                      }
                      .padding()
                  } else {
                      // After image is captured, show the image + redo/confirm
                      VStack {
                          Image(uiImage: capturedImage!)
                              .resizable()
                              .scaledToFit()
                              .frame(width: 300, height: 300)
                              .padding()
                          
                          HStack {
                              Button(action: {
                                  // Redo: clear the image, open camera again
                                  capturedImage = nil
                                  isCameraActive = true
                              }) {
                                  Text("Redo")
                                      .font(.title2)
                                      .foregroundColor(.white)
                                      .padding()
                                      .background(Color.red)
                                      .cornerRadius(10)
                              }
                              .padding()
                              
                              Spacer()
                              
                              Button(action: {
                                  // Confirm: move to category picker
                                  isCategorySelectionActive = true
                              }) {
                                  Text("Confirm")
                                      .font(.title2)
                                      .foregroundColor(.white)
                                      .padding()
                                      .background(Color.green)
                                      .cornerRadius(10)
                              }
                              .padding()
                          }
                          .padding(.horizontal)
                      }
                  }
                  
                  // Show the saved clothes
                  List {
                      ForEach(clothesGroups, id: \.id) { clothesGroup in
                          Section(header: Text(clothesGroup.category)) {
                              ForEach(clothesGroup.clothings, id: \.nameNum) { clothes in
                                  HStack {
                                      if let photo = clothes.photo {
                                          Image(uiImage: photo)
                                              .resizable()
                                              .scaledToFit()
                                              .frame(width: 50, height: 50)
                                      }
                                      Text(clothes.nameNum)
                                  }
                              }
                          }
                      }
                  }
              }
              .navigationTitle("Digital Closet")
          }
        
        //Present the camera view when the flag is set to true
        .sheet(isPresented: $isCameraActive)
        {
            CameraView(
                didCaptureImage: { image in
                    self.capturedImage = image
                },
                isCameraActive: $isCameraActive,
                capturedImage: $capturedImage
            )
        }
        
        
        
        .actionSheet(isPresented: $isCategorySelectionActive)
        {
            ActionSheet(
                title: Text("Select Category"),
                message: Text("Please choose a category for the clothing item."),
                buttons:
                [
                    .default(Text("Tops")) { saveImageToCategory("Tops") },
                    .default(Text("Bottoms")) { saveImageToCategory("Bottoms") },
                    .default(Text("Accessories")) { saveImageToCategory("Accessories") },
                    .default(Text("Shoes")) { saveImageToCategory("Shoes") },
                    .cancel() // Adds a cancel button to close the action sheet
                ]
                    
            )
        }
    //end of body
    }
        
        // Function to save the image to the selected category
        func saveImageToCategory(_ category: String) {
            // Find the index of the selected category in the clothesGroups array
            if let groupIndex = clothesGroups.firstIndex(where: { $0.category == category })
            {
                var group = clothesGroups[groupIndex] // Get the category group
                
                // Generate a new name for the clothing item based on the number of items already in the group
                let newNameNum = "\(category)\(group.clothings.count + 1)"
                
                // Create a new clothing item with the generated name, category, and captured image
                let newClothing = Clothes(nameNum: newNameNum, labels: category, photo: capturedImage)

                
                // Add the new clothing item to the appropriate category's clothings array
                group.clothings.append(newClothing)
                
                // Update the clothesGroups array with the modified category group
                clothesGroups[groupIndex] = group
                
                // Reset the captured image and hide the category selection alert
                capturedImage = nil
                isCategorySelectionActive = false
                
            }
        }
        
//end of view EVERYTHING
}

#Preview {
    ContentView()
}
