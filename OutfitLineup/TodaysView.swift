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
}

struct TimeSlot: Identifiable {
    let id = UUID()
    let time: String
}

struct TodaysView: View {
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var outfitSlots: [OutfitSlot] = [OutfitSlot()]

    var body: some View {
        VStack(alignment: .leading) {
            // Header with centered title + date and calendar icon
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 4) {
                    Text("OOTD")
                        .font(.system(size: 40, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(formattedDate(date: selectedDate))
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                // 📅 Calendar icon button
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
            
            // Outfit slots
            ForEach($outfitSlots) { $slot in
                HStack {
                    if let item = slot.selectedItem {
                        Image(systemName: item.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                    } else {
                        Button(action: {
                            // Placeholder: Pick clothing item
                            slot.selectedItem = ClothingItem(imageName: "tshirt.fill")
                        }) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding(.vertical, 4)
            }

            // Add clothing slot button
            Button(action: {
                outfitSlots.append(OutfitSlot())
            }) {
                HStack {
                    Image(systemName: "plus.app")
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
    }

    // Format the selected date
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
}

// Optional: If you want to reuse time slots later
func generateTimeSlots(for date: Date) -> [TimeSlot] {
    var slots: [TimeSlot] = []
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"

    var currentTime = Calendar.current.startOfDay(for: date)
    for _ in 0..<48 {
        slots.append(TimeSlot(time: formatter.string(from: currentTime)))
        currentTime = Calendar.current.date(byAdding: .minute, value: 30, to: currentTime)!
    }
    return slots
}

#Preview {
    TodaysView()
}
