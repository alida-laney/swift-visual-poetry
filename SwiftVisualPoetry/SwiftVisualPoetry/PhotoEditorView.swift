//
//  PhotoEditorView.swift
//  SwiftVisualPoetry
//
//  Created by Alida on 9/5/25.
//

import SwiftUI

struct PhotoEditorView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var textOverlays: [TextOverlay] = []
    @State private var isEditingText = false
    @State private var editingIndex: Int?
    @StateObject private var alignmentManager = AlignmentGuideManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                // Photo
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                
                // Text overlays
                ForEach(Array(textOverlays.enumerated()), id: \.element.id) { index, overlay in
                    DraggableTextView(
                        textOverlay: $textOverlays[index],
                        alignmentManager: alignmentManager,
                        canvasSize: geometry.size,
                        allTextOverlays: textOverlays
                    ) {
                        editText(at: index)
                    }
                    .opacity(isEditingText ? 0.3 : 1.0)
                }
                
                // Alignment guides
                ForEach(alignmentManager.activeGuides) { guide in
                    AlignmentGuideView(guide: guide, canvasSize: geometry.size)
                }
                
                // Controls (hide when editing)
                if !isEditingText {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Button("Cancel") {
                                dismiss()
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                            
                            Spacer()
                            
                            Button("Add Text") {
                                addNewText(in: geometry.size)
                            }
                            .buttonStyle(.borderedProminent)
                            .font(.headline)
                            
                            Spacer()
                            
                            Button("Save") {
                                // TODO: Implement save functionality
                                print("Save tapped with \(textOverlays.count) text overlays")
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 50)
                    }
                }
                
                // Inline text editor overlay
                if isEditingText, let editingIndex = editingIndex {
                    InlineTextEditingView(
                        textOverlay: $textOverlays[editingIndex],
                        isEditing: $isEditingText
                    )
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func addNewText(in size: CGSize) {
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        let newOverlay = TextOverlay(
            text: "Tap to edit",
            position: CGPoint(x: centerX, y: centerY)
        )
        
        textOverlays.append(newOverlay)
        
        // Immediately open inline editor for new text
        editingIndex = textOverlays.count - 1
        isEditingText = true
    }
    
    private func editText(at index: Int) {
        guard index < textOverlays.count else { return }
        
        editingIndex = index
        isEditingText = true
    }
}