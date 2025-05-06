//
//  ContentView.swift
//  OutfitLineup
//
//  Created by Rahman, Elise (513171) on 4/29/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0 // CHANGED: Default to TodaysView

    // Shared clothes data
    @State var clothesGroups = [
        ClothesGroup(id: 0, category: "Tops", clothings: []),
        ClothesGroup(id: 1, category: "Bottoms", clothings: []),
        ClothesGroup(id: 2, category: "Accessories", clothings: []),
        ClothesGroup(id: 3, category: "Shoes", clothings: [])
    ]

    @State private var isCameraActive = false
    @State private var capturedImage: UIImage? = nil
    @State private var isCategorySelectionActive = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // MAIN VIEWS BASED ON TABS
                Group {
                    switch selectedTab {
                    case 0:
                        TodaysView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white)
                        
                    case 1:
                        mainTrackingView
                        
                    case 2:
                        DigiClosetView(clothesGroups: clothesGroups, selectedCategory: "All") // FIXED
                        
                    default:
                        Text("Invalid tab")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)

                // BOTTOM TOOLBAR
                HStack {
                    Spacer()

                    // Left: Todays View
                    Button(action: {
                        selectedTab = 0
                    }) {
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.brown)
                    }

                    Spacer()

                    // Middle: Camera
                    Button(action: {
                        isCameraActive = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.cyan)
                            .padding(.bottom, 10)
                    }

                    Spacer()

                    // Right: Closet View
                    Button(action: {
                        selectedTab = 2
                    }) {
                        Image("closet") // your asset
                            .resizable()
                            .frame(width: 35, height: 35)
                            .aspectRatio(contentMode: .fit)
                    }

                    Spacer()
                }
                .padding(.vertical, 10)
                .background(Color.white.shadow(radius: 5))
            }

            // Show camera sheet
            .sheet(isPresented: $isCameraActive) {
                CameraView(
                    didCaptureImage: { image in
                        self.capturedImage = image
                    },
                    isCameraActive: $isCameraActive,
                    capturedImage: $capturedImage
                )
            }

            // Category action sheet
            .actionSheet(isPresented: $isCategorySelectionActive) {
                ActionSheet(
                    title: Text("Select Category"),
                    message: Text("Choose a category for the item."),
                    buttons: [
                        .default(Text("Tops")) { saveImageToCategory("Tops") },
                        .default(Text("Bottoms")) { saveImageToCategory("Bottoms") },
                        .default(Text("Accessories")) { saveImageToCategory("Accessories") },
                        .default(Text("Shoes")) { saveImageToCategory("Shoes") },
                        .cancel()
                    ]
                )
            }
        }
    }

    // TEMP TRACKING VIEW WITH REDO/CONFIRM
    var mainTrackingView: some View {
        VStack {
            if capturedImage == nil {
                Text("Press the + button to track a clothing item")
                    .foregroundColor(.gray)
            } else {
                VStack {
                    Image(uiImage: capturedImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)

                    HStack {
                        Button(action: {
                            capturedImage = nil
                            isCameraActive = true
                        }) {
                            Text("Redo")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }

                        Spacer()

                        Button(action: {
                            isCategorySelectionActive = true
                        }) {
                            Text("Confirm")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
    }

    func saveImageToCategory(_ category: String) {
        if let groupIndex = clothesGroups.firstIndex(where: { $0.category == category }) {
            var group = clothesGroups[groupIndex]
            let newNameNum = "\(category)\(group.clothings.count + 1)"
            let newClothing = Clothes(nameNum: newNameNum, labels: category, photo: capturedImage)
            group.clothings.append(newClothing)
            clothesGroups[groupIndex] = group
            capturedImage = nil
            isCategorySelectionActive = false
        }
    }
}

#Preview {
    ContentView()
}
