//
//  DraggableTextView.swift
//  SwiftVisualPoetry
//
//  Created by Alida on 9/5/25.
//

import SwiftUI

struct DraggableTextView: View {
    @Binding var textOverlay: TextOverlay
    let alignmentManager: AlignmentGuideManager
    let canvasSize: CGSize
    let allTextOverlays: [TextOverlay]
    let onTap: () -> Void
    
    @State private var dragOffset = CGSize.zero
    @State private var magnification: CGFloat = 1.0
    @State private var isDragging = false
    @State private var isResizing = false
    @State private var initialScale: CGFloat = 1.0
    @State private var dragStartLocation = CGPoint.zero
    
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
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        dragOffset = value.translation
                        
                        // Calculate potential new position
                        let potentialPosition = CGPoint(
                            x: textOverlay.position.x + value.translation.width,
                            y: textOverlay.position.y + value.translation.height
                        )
                        
                        // Create a temporary text overlay with the new position for guide calculations
                        var tempOverlay = textOverlay
                        tempOverlay.position = potentialPosition
                        
                        // Update alignment guides
                        alignmentManager.updateGuides(
                            for: tempOverlay,
                            in: canvasSize,
                            with: allTextOverlays
                        )
                    }
                    .onEnded { value in
                        isDragging = false
                        
                        // Calculate final position
                        let newPosition = CGPoint(
                            x: textOverlay.position.x + value.translation.width,
                            y: textOverlay.position.y + value.translation.height
                        )
                        
                        // Apply snapping if guides are active
                        let snappedPosition = alignmentManager.snapPosition(
                            newPosition,
                            to: alignmentManager.activeGuides
                        )
                        
                        // Update text position
                        textOverlay.position = snappedPosition
                        dragOffset = .zero
                        
                        // Clear guides after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            alignmentManager.clearGuides()
                        }
                    }
            )
    }
}

#Preview {
    @Previewable @State var sampleOverlay = TextOverlay(text: "Sample Text")
    @Previewable @StateObject var alignmentManager = AlignmentGuideManager()
    
    ZStack {
        Color.black.ignoresSafeArea()
        
        DraggableTextView(
            textOverlay: $sampleOverlay,
            alignmentManager: alignmentManager,
            canvasSize: CGSize(width: 400, height: 600),
            allTextOverlays: []
        ) {
            print("Text tapped")
        }
    }
}