//
//  AlignmentGuide.swift
//  SwiftVisualPoetry
//
//  Created by Alida on 9/5/25.
//

import SwiftUI

struct AlignmentGuide: Identifiable {
    let id = UUID()
    let position: CGFloat
    let type: GuideType
    let orientation: GuideOrientation
    
    enum GuideType {
        case imageCenter
        case imageEdge
        case textAlignment
    }
    
    enum GuideOrientation {
        case horizontal
        case vertical
    }
}

struct AlignmentGuideView: View {
    let guide: AlignmentGuide
    let canvasSize: CGSize
    
    var body: some View {
        Group {
            if guide.orientation == .horizontal {
                // Horizontal guide line
                Rectangle()
                    .fill(Color.blue.opacity(0.8))
                    .frame(height: 2)
                    .position(x: canvasSize.width / 2, y: guide.position)
            } else {
                // Vertical guide line
                Rectangle()
                    .fill(Color.blue.opacity(0.8))
                    .frame(width: 2)
                    .position(x: guide.position, y: canvasSize.height / 2)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: guide.position)
    }
}

class AlignmentGuideManager: ObservableObject {
    @Published var activeGuides: [AlignmentGuide] = []
    
    private let snapThreshold: CGFloat = 20 // Pixels to snap within
    
    func calculateGuides(
        for draggingText: TextOverlay,
        in canvasSize: CGSize,
        with otherTexts: [TextOverlay]
    ) -> [AlignmentGuide] {
        var guides: [AlignmentGuide] = []
        let textPosition = draggingText.position
        
        // Image center guides
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        
        if abs(textPosition.x - centerX) < snapThreshold {
            guides.append(AlignmentGuide(
                position: centerX,
                type: .imageCenter,
                orientation: .vertical
            ))
        }
        
        if abs(textPosition.y - centerY) < snapThreshold {
            guides.append(AlignmentGuide(
                position: centerY,
                type: .imageCenter,
                orientation: .horizontal
            ))
        }
        
        // Image edge guides
        let margins: CGFloat = 20
        let leftEdge = margins
        let rightEdge = canvasSize.width - margins
        let topEdge = margins
        let bottomEdge = canvasSize.height - margins
        
        if abs(textPosition.x - leftEdge) < snapThreshold {
            guides.append(AlignmentGuide(
                position: leftEdge,
                type: .imageEdge,
                orientation: .vertical
            ))
        }
        
        if abs(textPosition.x - rightEdge) < snapThreshold {
            guides.append(AlignmentGuide(
                position: rightEdge,
                type: .imageEdge,
                orientation: .vertical
            ))
        }
        
        if abs(textPosition.y - topEdge) < snapThreshold {
            guides.append(AlignmentGuide(
                position: topEdge,
                type: .imageEdge,
                orientation: .horizontal
            ))
        }
        
        if abs(textPosition.y - bottomEdge) < snapThreshold {
            guides.append(AlignmentGuide(
                position: bottomEdge,
                type: .imageEdge,
                orientation: .horizontal
            ))
        }
        
        // Text-to-text alignment guides
        for otherText in otherTexts {
            if otherText.id == draggingText.id { continue }
            
            // Horizontal alignment (same Y position)
            if abs(textPosition.y - otherText.position.y) < snapThreshold {
                guides.append(AlignmentGuide(
                    position: otherText.position.y,
                    type: .textAlignment,
                    orientation: .horizontal
                ))
            }
            
            // Vertical alignment (same X position)
            if abs(textPosition.x - otherText.position.x) < snapThreshold {
                guides.append(AlignmentGuide(
                    position: otherText.position.x,
                    type: .textAlignment,
                    orientation: .vertical
                ))
            }
        }
        
        return guides
    }
    
    func snapPosition(
        _ position: CGPoint,
        to guides: [AlignmentGuide]
    ) -> CGPoint {
        var snappedPosition = position
        
        // Snap to horizontal guides (adjust Y)
        if let horizontalGuide = guides.first(where: { $0.orientation == .horizontal }) {
            snappedPosition.y = horizontalGuide.position
        }
        
        // Snap to vertical guides (adjust X)
        if let verticalGuide = guides.first(where: { $0.orientation == .vertical }) {
            snappedPosition.x = verticalGuide.position
        }
        
        return snappedPosition
    }
    
    func updateGuides(
        for draggingText: TextOverlay,
        in canvasSize: CGSize,
        with otherTexts: [TextOverlay]
    ) {
        activeGuides = calculateGuides(
            for: draggingText,
            in: canvasSize,
            with: otherTexts
        )
    }
    
    func clearGuides() {
        activeGuides.removeAll()
    }
}