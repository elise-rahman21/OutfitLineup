//
//  TodaysView.swift
//  OutfitLineup
//
//  Created by Hendrix, Skyla (514100) on 4/29/25.
//
import SwiftUI

struct ClothingItem: Identifiable {
    let id = UUID()
    var imageName: String
}

struct OutfitSlot: Identifiable {
    let id = UUID()
    var selectedItem: ClothingItem?
    var selectedCategory: String = "Select Category"
}

struct TodaysView: View {
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var outfitSlots: [OutfitSlot] = [OutfitSlot()]
    let categories = ["Tops", "Bottoms", "Shoes", "Accessories"]
    @State private var navigateToCloset = false
    @State private var selectedClosetCategory = ""

    // Example clothes groups (Replace with real data)
    let yourClothesGroupsArray: [ClothesGroup] = [
        ClothesGroup(id: 1, category: "Tops", clothings: []),
        ClothesGroup(id: 2, category: "Bottoms", clothings: []),
        ClothesGroup(id: 3, category: "Shoes", clothings: []),
        ClothesGroup(id: 4, category: "Accessories", clothings: [])
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 4) {
                        Text("OOTD")
                            .font(.system(size: 40, weight: .medium))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text(formattedDate(date: selectedDate))
                            .font(.headline)
                            .foregroundColor(.gray)
                    }

                    Button(action: {
                        showDatePicker.toggle()
                    }) {
                        Text("🗓️")
                            .font(.system(size: 35))
                    }
                    .popover(isPresented: $showDatePicker) {
                        VStack {
                            DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .padding()
                        }
                        .frame(width: 300)
                    }
                    .padding(.top, 4)
                    .padding(.trailing)
                }
                .padding(.bottom, 10)

                // Outfit slots with a dropdown menu for categories
                ForEach($outfitSlots) { $slot in
                    Menu {
                        ForEach(categories, id: \.self) { category in
                            Button(category) {
                                slot.selectedCategory = category
                                selectedClosetCategory = category  // Update selected category
                                navigateToCloset = true  // Trigger navigation
                            }
                        }
                    } label: {
                        HStack {
                            Text(slot.selectedCategory)
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.bottom, 4)
                }

                // Add new outfit slot button
                Button(action: {
                    outfitSlots.append(OutfitSlot())
                }) {
                    HStack {
                        Image(systemName: "plus.app")
                        Text("Add Clothing Slot")
                    }
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
                }

                Spacer()
            }
            .padding()

            // NavigationLink to DigiClosetView
            NavigationLink(destination: DigiClosetView(clothesGroups: yourClothesGroupsArray, selectedCategory: selectedClosetCategory), isActive: $navigateToCloset) {
                EmptyView()  // NavigationLink doesn't show anything here, just triggering navigation
            }
        }
    }

    // Function to format the selected date
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
}
