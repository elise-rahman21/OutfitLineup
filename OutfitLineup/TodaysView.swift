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

    @State private var outfitDataByDate: [String: [OutfitSlot]] = [:] // key = formatted date string
    @State private var outfitSlots: [OutfitSlot] = [OutfitSlot()]

    let categories = ["Tops", "Bottoms", "Shoes", "Accessories"]
    @State private var navigateToCloset = false
    @State private var selectedClosetCategory = ""

    let yourClothesGroupsArray: [ClothesGroup] = [
        ClothesGroup(id: 1, category: "Tops", clothings: []),
        ClothesGroup(id: 2, category: "Bottoms", clothings: []),
        ClothesGroup(id: 3, category: "Shoes", clothings: []),
        ClothesGroup(id: 4, category: "Accessories", clothings: [])
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                //  Background image
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.2)
                    .ignoresSafeArea()

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
                                    .onChange(of: selectedDate) { _ in
                                        loadOutfitForDate()
                                    }
                                    .padding()
                            }
                            .frame(width: 300)
                        }
                        .padding(.top, 4)
                        .padding(.trailing)
                    }
                    .padding(.bottom, 10)

                    ForEach($outfitSlots) { $slot in
                    // ⬇️ Wrap the button in HStack and center it horizontally
                    HStack {
                      Menu {
                        ForEach(categories, id: \.self) { category in
                            Button(category) {
                            slot.selectedCategory = category
                            selectedClosetCategory = category
                            navigateToCloset = true
                            }
                            }
                        } label: {
                        HStack {
                        Text(slot.selectedCategory)
                        Image(systemName: "chevron.down")
                        }
                        .padding()
                        .frame(width: 250) // Button width
                        .background(Color.gray) // ⬅️ Changed from blue to gray
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        }
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // ⬅️ Center horizontally
                        .padding(.bottom, 4)
                        }

                       // ⬇️ Wrap Add Clothing Slot button in HStack and center it
                       HStack {
                       Button(action: {
                         outfitSlots.append(OutfitSlot())
                         saveOutfitForDate()
                       }) {
                       HStack {
                         Image(systemName: "plus.app")
                         Text("Add Clothing Slot")
                       }
                       .padding()
                       .background(Color(red: 1.5, green: 0.8, blue: 0.9))
                       .foregroundColor(.white)
                       .cornerRadius(10)
                       }
                       }
                       .frame(maxWidth: .infinity, alignment: .center) // ⬅️ Center horizontally

                       Spacer()
                       }
                        .padding()
            }
            .onChange(of: outfitSlots.map { $0.selectedCategory }) { _ in
                saveOutfitForDate()
            }
            .onAppear {
                loadOutfitForDate()
            }

            NavigationLink(
                destination: DigiClosetView(
                    clothesGroups: yourClothesGroupsArray,
                    selectedCategory: selectedClosetCategory
                ),
                isActive: $navigateToCloset
            ) {
                EmptyView()
            }
        }
    }

    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }

    func loadOutfitForDate() {
        let key = formattedDate(date: selectedDate)
        outfitSlots = outfitDataByDate[key] ?? [OutfitSlot()]
    }

    func saveOutfitForDate() {
        let key = formattedDate(date: selectedDate)
        outfitDataByDate[key] = outfitSlots
    }
}
