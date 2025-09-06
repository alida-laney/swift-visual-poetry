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
    @State private var magnification: CGFloat = 1.0
    @State private var isDragging = false
    @State private var isResizing = false
    @State private var initialScale: CGFloat = 1.0
    @State private var dragStartLocation = CGPoint.zero
    let onTap: () -> Void
    
    var body: some View {
        Text(textOverlay.text)
            .font(.system(size: textOverlay.fontSize, weight: textOverlay.fontWeight))
            .foregroundColor(textOverlay.color)
            .multilineTextAlignment(textOverlay.alignment)
            .scaleEffect(textOverlay.scale * magnification)
            .rotationEffect(.degrees(textOverlay.rotation))
            .opacity(isDragging ? 0.8 : (isResizing ? 0.9 : 1.0)) // Visual feedback when dragging or resizing
            .position(x: textOverlay.position.x + dragOffset.width,
                     y: textOverlay.position.y + dragOffset.height)
            .onTapGesture {
                onTap()
            }
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        let isOptionPressed = NSEvent.modifierFlags.contains(.option)
                        
                        if isOptionPressed {
                            // Resize mode - vertical drag changes size
                            if !isResizing {
                                isResizing = true
                                initialScale = textOverlay.scale
                                dragStartLocation = value.startLocation
                            }
                            
                            let verticalChange = value.location.y - dragStartLocation.y
                            let sensitivity: CGFloat = 0.01
                            let scaleMultiplier = 1.0 + (verticalChange * sensitivity)
                            let newScale = initialScale * scaleMultiplier
                            
                            magnification = max(0.3, min(newScale, 3.0)) / textOverlay.scale
                        } else {
                            // Move mode - drag repositions text
                            if !isDragging {
                                isDragging = true
                            }
                            dragOffset = value.translation
                        }
                    }
                    .onEnded { value in
                        let isOptionPressed = NSEvent.modifierFlags.contains(.option)
                        
                        if isResizing && isOptionPressed {
                            // Apply resize
                            textOverlay.scale *= magnification
                            textOverlay.scale = max(0.3, min(textOverlay.scale, 3.0))
                            magnification = 1.0
                            isResizing = false
                        } else if isDragging {
                            // Apply movement
                            textOverlay.position = CGPoint(
                                x: textOverlay.position.x + value.translation.width,
                                y: textOverlay.position.y + value.translation.height
                            )
                            dragOffset = .zero
                            isDragging = false
                        }
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