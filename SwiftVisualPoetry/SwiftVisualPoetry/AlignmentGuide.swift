//
//  AlignmentGuide.swift
//  SwiftVisualPoetry
//
//  Created by Alida on 9/5/25.
//

import SwiftUI
import UIKit

struct AlignmentGuide: Identifiable {
    let id = UUID()
    let position: CGFloat
    let type: GuideType
    let orientation: GuideOrientation
    
    enum GuideType {
        case imageCenter
        case imageEdge
        case textAlignment
        case textEdge
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
                if guide.type == .imageEdge || guide.type == .textEdge {
                    // Dashed line for edges
                    HStack(spacing: 3) {
                        ForEach(0..<Int(canvasSize.width / 8), id: \.self) { _ in
                            Rectangle()
                                .fill(Color.blue.opacity(0.4))
                                .frame(width: 5, height: 2)
                        }
                    }
                    .position(x: canvasSize.width / 2, y: guide.position)
                } else {
                    // Solid line for center and text alignment
                    Rectangle()
                        .fill(Color.blue.opacity(0.8))
                        .frame(width: canvasSize.width, height: 2)
                        .position(x: canvasSize.width / 2, y: guide.position)
                }
            } else {
                // Vertical guide line
                if guide.type == .imageEdge || guide.type == .textEdge {
                    // Dashed line for edges
                    VStack(spacing: 3) {
                        ForEach(0..<Int(canvasSize.height / 8), id: \.self) { _ in
                            Rectangle()
                                .fill(Color.blue.opacity(0.4))
                                .frame(width: 2, height: 5)
                        }
                    }
                    .position(x: guide.position, y: canvasSize.height / 2)
                } else {
                    // Solid line for center and text alignment
                    Rectangle()
                        .fill(Color.blue.opacity(0.8))
                        .frame(width: 2, height: canvasSize.height)
                        .position(x: guide.position, y: canvasSize.height / 2)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: guide.position)
    }
}


class AlignmentGuideManager: ObservableObject {
    @Published var activeGuides: [AlignmentGuide] = []
    
    private let snapThreshold: CGFloat = 10 // Pixels to snap within
    
    private func calculateTextSize(text: String, fontSize: CGFloat, fontWeight: Font.Weight, scale: CGFloat, maxWidth: CGFloat) -> CGSize {
        let uiFont = UIFont.systemFont(ofSize: fontSize * scale, weight: fontWeight.uiKitWeight)
        let attributes = [NSAttributedString.Key.font: uiFont]
        let constraintRect = CGRect(x: 0, y: 0, width: maxWidth, height: .greatestFiniteMagnitude)
        
        let boundingRect = text.boundingRect(
            with: constraintRect.size,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )
        
        return CGSize(
            width: ceil(boundingRect.width),
            height: ceil(boundingRect.height)
        )
    }
    
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
        let imageMargins: CGFloat = 30
        let leftEdge = imageMargins
        let rightEdge = canvasSize.width - imageMargins
        let topEdge = imageMargins
        let bottomEdge = canvasSize.height - imageMargins
        
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
            
            // Calculate accurate text dimensions using boundingRect
            let textSize = calculateTextSize(
                text: otherText.text,
                fontSize: otherText.fontSize,
                fontWeight: otherText.fontWeight,
                scale: otherText.scale,
                maxWidth: canvasSize.width * 0.8 // Allow some margin for text wrapping
            )
            let textHeight = textSize.height
            let textWidth = textSize.width
            
            let textTop = otherText.position.y - textHeight / 2
            let textBottom = otherText.position.y + textHeight / 2
            // Adjust for text alignment - left/center/right affects visual positioning
            let textLeft: CGFloat
            let textRight: CGFloat
            
            switch otherText.alignment {
            case .leading:
                textLeft = otherText.position.x
                textRight = otherText.position.x + textWidth
            case .trailing:
                textLeft = otherText.position.x - textWidth
                textRight = otherText.position.x
            default: // .center
                textLeft = otherText.position.x - textWidth / 2
                textRight = otherText.position.x + textWidth / 2
            }
            
            // Calculate accurate dragging text dimensions using boundingRect
            let draggingTextSize = calculateTextSize(
                text: draggingText.text,
                fontSize: draggingText.fontSize,
                fontWeight: draggingText.fontWeight,
                scale: draggingText.scale,
                maxWidth: canvasSize.width * 0.8
            )
            let draggingTextHeight = draggingTextSize.height
            let draggingTextWidth = draggingTextSize.width
            let draggingTextTop = textPosition.y - draggingTextHeight / 2
            let draggingTextBottom = textPosition.y + draggingTextHeight / 2
            // Adjust for dragging text alignment
            let draggingTextLeft: CGFloat
            let draggingTextRight: CGFloat
            
            switch draggingText.alignment {
            case .leading:
                draggingTextLeft = textPosition.x
                draggingTextRight = textPosition.x + draggingTextWidth
            case .trailing:
                draggingTextLeft = textPosition.x - draggingTextWidth
                draggingTextRight = textPosition.x
            default: // .center
                draggingTextLeft = textPosition.x - draggingTextWidth / 2
                draggingTextRight = textPosition.x + draggingTextWidth / 2
            }
            
            // Horizontal alignment (same Y position - center)
            if abs(textPosition.y - otherText.position.y) < snapThreshold {
                guides.append(AlignmentGuide(
                    position: otherText.position.y,
                    type: .textAlignment,
                    orientation: .horizontal
                ))
            }
            
            // Text top edge alignment - show when dragging text bottom edge aligns with other text top
            if abs(draggingTextBottom - textTop) < snapThreshold {
                guides.append(AlignmentGuide(
                    position: textTop,
                    type: .textEdge,
                    orientation: .horizontal
                ))
            }
            
            // Text bottom edge alignment - show when dragging text top edge aligns with other text bottom
            if abs(draggingTextTop - textBottom) < snapThreshold {
                guides.append(AlignmentGuide(
                    position: textBottom,
                    type: .textEdge,
                    orientation: .horizontal
                ))
            }
            
            // Also check for any proximity to text edges (more generous)
            if abs(textPosition.y - textTop) < snapThreshold * 1.5 {
                guides.append(AlignmentGuide(
                    position: textTop,
                    type: .textEdge,
                    orientation: .horizontal
                ))
            }
            
            if abs(textPosition.y - textBottom) < snapThreshold * 1.5 {
                guides.append(AlignmentGuide(
                    position: textBottom,
                    type: .textEdge,
                    orientation: .horizontal
                ))
            }
            
            // Vertical alignment (same X position - center)
            if abs(textPosition.x - otherText.position.x) < snapThreshold {
                guides.append(AlignmentGuide(
                    position: otherText.position.x,
                    type: .textAlignment,
                    orientation: .vertical
                ))
            }
            
            // Text left edge alignment - show when dragging text right edge aligns with other text left
            if abs(draggingTextRight - textLeft) < snapThreshold {
                guides.append(AlignmentGuide(
                    position: textLeft,
                    type: .textEdge,
                    orientation: .vertical
                ))
            }
            
            // Text right edge alignment - show when dragging text left edge aligns with other text right
            if abs(draggingTextLeft - textRight) < snapThreshold {
                guides.append(AlignmentGuide(
                    position: textRight,
                    type: .textEdge,
                    orientation: .vertical
                ))
            }
        }
        
        // Photo margin guides - show when text edges align with photo margins
        let photoMargins: CGFloat = 30
        let leftMargin = photoMargins
        let rightMargin = canvasSize.width - photoMargins
        let topMargin = photoMargins
        let bottomMargin = canvasSize.height - photoMargins
        
        // Calculate accurate dragging text dimensions for margin detection
        let dragTextSize = calculateTextSize(
            text: draggingText.text,
            fontSize: draggingText.fontSize,
            fontWeight: draggingText.fontWeight,
            scale: draggingText.scale,
            maxWidth: canvasSize.width * 0.8
        )
        let dragTextHeight = dragTextSize.height
        let dragTextWidth = dragTextSize.width
        let dragTextTop = textPosition.y - dragTextHeight / 2
        let dragTextBottom = textPosition.y + dragTextHeight / 2
        // Adjust for dragging text alignment for margin detection
        let dragTextLeft: CGFloat
        let dragTextRight: CGFloat
        
        switch draggingText.alignment {
        case .leading:
            dragTextLeft = textPosition.x
            dragTextRight = textPosition.x + dragTextWidth
        case .trailing:
            dragTextLeft = textPosition.x - dragTextWidth
            dragTextRight = textPosition.x
        default: // .center
            dragTextLeft = textPosition.x - dragTextWidth / 2
            dragTextRight = textPosition.x + dragTextWidth / 2
        }
        
        // Top margin alignment
        if abs(dragTextTop - topMargin) < snapThreshold {
            guides.append(AlignmentGuide(
                position: topMargin,
                type: .imageEdge,
                orientation: .horizontal
            ))
        }
        
        // Bottom margin alignment
        if abs(dragTextBottom - bottomMargin) < snapThreshold {
            guides.append(AlignmentGuide(
                position: bottomMargin,
                type: .imageEdge,
                orientation: .horizontal
            ))
        }
        
        // Left margin alignment
        if abs(dragTextLeft - leftMargin) < snapThreshold {
            guides.append(AlignmentGuide(
                position: leftMargin,
                type: .imageEdge,
                orientation: .vertical
            ))
        }
        
        // Right margin alignment
        if abs(dragTextRight - rightMargin) < snapThreshold {
            guides.append(AlignmentGuide(
                position: rightMargin,
                type: .imageEdge,
                orientation: .vertical
            ))
        }
        
        return guides
    }
    
    func snapPosition(
        _ position: CGPoint,
        to guides: [AlignmentGuide]
    ) -> CGPoint {
        var snappedPosition = position
        
        // Snap to horizontal guides (adjust Y) - only snap to center alignment and image center, not edges
        if let horizontalGuide = guides.first(where: { $0.orientation == .horizontal && ($0.type == .textAlignment || $0.type == .imageCenter) }) {
            snappedPosition.y = horizontalGuide.position
        }
        
        // Snap to vertical guides (adjust X) - only snap to center alignment and image center, not edges
        if let verticalGuide = guides.first(where: { $0.orientation == .vertical && ($0.type == .textAlignment || $0.type == .imageCenter) }) {
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

extension Font.Weight {
    var uiKitWeight: UIFont.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        default: return .regular
        }
    }
}