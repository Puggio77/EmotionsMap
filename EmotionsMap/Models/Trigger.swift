//
//  Trigger.swift
//  EmotionsMap
//
//  Created by Leo A.Molina on 23/02/26.
//

import Foundation
import SwiftData
import SwiftUI


@Model
final class Trigger {
    var name: String        // Name of the trigger
    var icon: String        // Emoji representing the trigger
    var colorHex: String    // Color of the trigger
    
    init(name: String = "Stress", icon: String = "🫩", colorHex: String = "FFFFFF") {
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
    }
    
    var color: Color {
        get { Color(colorHex) }
        set { colorHex = newValue.toHex() } 
    }
}
