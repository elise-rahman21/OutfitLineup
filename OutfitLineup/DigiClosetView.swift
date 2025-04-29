//
//  DigiClosetView.swift
//  OutfitLineup
//
//  Created by Rahman, Elise (513171) on 4/29/25.
//

import SwiftUI

struct DigiClosetView: View {
    var clothesGroups: [ClothesGroup]

    @State private var selectedCategory: String = "All"

    var filteredClothes: [Clothes] {
        if selectedCategory == "All" {
            return clothesGroups.flatMap { $0.clothings }
        } else {
            return clothesGroups.first(where: { $0.category == selectedCategory })?.clothings ?? []
        }
    }

    var body: some View {
        VStack {
            // CATEGORY BUTTONS
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(["All", "Tops", "Bottoms", "Accessories", "Shoes"], id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                }.padding()
            }

            // CLOTHES GRID
            if filteredClothes.isEmpty {
                Spacer()
                Text("No clothes yet in this category.")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 20)], spacing: 20) {
                        ForEach(filteredClothes, id: \.nameNum) { clothing in
                            VStack {
                                if let image = clothing.photo {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .cornerRadius(10)
                                }
                                Text(clothing.nameNum)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("My Closet")
    }
}

