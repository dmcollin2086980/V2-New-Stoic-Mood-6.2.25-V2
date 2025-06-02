//
//  Item.swift
//  New Stoic Mood 6.2.25
//
//  Created by Daniel Collinsworth on 6/2/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
