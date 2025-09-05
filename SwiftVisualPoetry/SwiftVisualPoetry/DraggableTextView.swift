//
//  DraggableTextView.swift
//  SwiftVisualPoetry
//
//  Created by Alida on 9/5/25.
//

import SwiftUI

struct DraggableTextView: View {
    @Binding var textOverlay: TextOverlay
    @State private var dragOffset = CGSize.zero
    @State private var lastDragPosition = CGPoint.zero
    let onTap: () -> Void
    
    var body: some View {
        Text(textOverlay.text)
            .font(.system(size: textOverlay.fontSize, weight: textOverlay.fontWeight))
            .foregroundColor(textOverlay.color)
            .scaleEffect(textOverlay.scale)
            .rotationEffect(.degrees(textOverlay.rotation))
            .position(x: textOverlay.position.x + dragOffset.width,
                     y: textOverlay.position.y + dragOffset.height)
            .onTapGesture {
                onTap()
            }
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        // Update the text overlay's position
                        textOverlay.position = CGPoint(
                            x: textOverlay.position.x + value.translation.width,
                            y: textOverlay.position.y + value.translation.height
                        )
                        
                        // Reset drag offset
                        dragOffset = .zero
                    }
            )
    }
}

#Preview {
    @Previewable @State var sampleOverlay = TextOverlay(text: "Sample Text")
    
    ZStack {
        Color.black.ignoresSafeArea()
        
        DraggableTextView(textOverlay: $sampleOverlay) {
            print("Text tapped")
        }
    }
}