//
//  Clothes.swift
//  OutfitLineup
//
//  Created by Rahman, Elise (513171) on 4/29/25.
//

import SwiftUI

struct Clothes: Hashable {
    
    var id = UUID() // Unique identifier for each clothing item (UUID ensures uniqueness)
    var nameNum: String // Unique identifier like "Tops1"
    var labels: String // category label like "tops"
    var photo: UIImage? // Optional photo for the clothing item

    
}
