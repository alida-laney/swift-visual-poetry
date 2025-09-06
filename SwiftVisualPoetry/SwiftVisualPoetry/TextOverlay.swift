//
//  TextOverlay.swift
//  SwiftVisualPoetry
//
//  Created by Alida on 9/5/25.
//

import SwiftUI

struct TextOverlay: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var position: CGPoint
    var scale: CGFloat
    var rotation: Double
    var color: Color
    var fontSize: CGFloat
    var fontWeight: Font.Weight
    var alignment: TextAlignment
    
    init(
        text: String = "Tap to edit",
        position: CGPoint = CGPoint(x: 200, y: 200),
        scale: CGFloat = 1.0,
        rotation: Double = 0.0,
        color: Color = .white,
        fontSize: CGFloat = 24,
        fontWeight: Font.Weight = .bold,
        alignment: TextAlignment = .center
    ) {
        self.text = text
        self.position = position
        self.scale = scale
        self.rotation = rotation
        self.color = color
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.alignment = alignment
    }
}