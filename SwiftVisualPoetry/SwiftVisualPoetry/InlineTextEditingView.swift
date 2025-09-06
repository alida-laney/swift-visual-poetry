//
//  InlineTextEditingView.swift
//  SwiftVisualPoetry
//
//  Created by Alida on 9/5/25.
//

import SwiftUI

struct InlineTextEditingView: View {
    @Binding var textOverlay: TextOverlay
    @Binding var isEditing: Bool
    @State private var editedText: String
    @FocusState private var isTextFieldFocused: Bool
    
    init(textOverlay: Binding<TextOverlay>, isEditing: Binding<Bool>) {
        self._textOverlay = textOverlay
        self._isEditing = isEditing
        self._editedText = State(initialValue: textOverlay.wrappedValue.text)
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent overlay
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    finishEditing()
                }
            
            VStack(spacing: 25) {
                Spacer()
                
                // Combined text input and preview area
                VStack(spacing: 20) {
                    ZStack {
                        // Placeholder when empty
                        if editedText.isEmpty {
                            VStack {
                                Text("Tap to type")
                                    .font(.system(size: textOverlay.fontSize, weight: textOverlay.fontWeight))
                                    .foregroundColor(textOverlay.color.opacity(0.5))
                                    .multilineTextAlignment(textOverlay.alignment)
                                Spacer()
                            }
                        }
                        
                        // Actual text editor for multiline support
                        TextEditor(text: $editedText)
                            .font(.system(size: textOverlay.fontSize, weight: textOverlay.fontWeight))
                            .foregroundColor(textOverlay.color)
                            .multilineTextAlignment(textOverlay.alignment)
                            .focused($isTextFieldFocused)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                }
                
                Spacer()
                
                // Color picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ColorPickerButton(color: .white, selectedColor: $textOverlay.color)
                        ColorPickerButton(color: .black, selectedColor: $textOverlay.color)
                        ColorPickerButton(color: .red, selectedColor: $textOverlay.color)
                        ColorPickerButton(color: .blue, selectedColor: $textOverlay.color)
                        ColorPickerButton(color: .green, selectedColor: $textOverlay.color)
                        ColorPickerButton(color: .yellow, selectedColor: $textOverlay.color)
                        ColorPickerButton(color: .purple, selectedColor: $textOverlay.color)
                        ColorPickerButton(color: .orange, selectedColor: $textOverlay.color)
                        ColorPickerButton(color: .pink, selectedColor: $textOverlay.color)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Text alignment picker
                VStack(spacing: 10) {
                    HStack {
                        Text("Alignment")
                            .foregroundColor(.white)
                            .font(.caption)
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    
                    HStack(spacing: 15) {
                        AlignmentButton(alignment: .leading, selectedAlignment: $textOverlay.alignment, icon: "text.alignleft")
                        AlignmentButton(alignment: .center, selectedAlignment: $textOverlay.alignment, icon: "text.aligncenter")
                        AlignmentButton(alignment: .trailing, selectedAlignment: $textOverlay.alignment, icon: "text.alignright")
                    }
                }
                
                // Size and weight controls
                VStack(spacing: 20) {
                    // Font size slider
                    VStack(spacing: 10) {
                        HStack {
                            Text("Size")
                                .foregroundColor(.white)
                                .font(.caption)
                            Spacer()
                            Text("\(Int(textOverlay.fontSize))")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        
                        Slider(value: $textOverlay.fontSize, in: 16...64, step: 2)
                            .accentColor(.white)
                    }
                    .padding(.horizontal, 40)
                    
                    // Font weight picker
                    HStack(spacing: 15) {
                        ForEach(FontWeightOption.allCases, id: \.self) { option in
                            Button(option.displayName) {
                                textOverlay.fontWeight = option.weight
                            }
                            .font(.caption)
                            .foregroundColor(textOverlay.fontWeight == option.weight ? .black : .white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(textOverlay.fontWeight == option.weight ? Color.white : Color.clear)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                        }
                    }
                }
                
                // Done button
                Button("Done") {
                    finishEditing()
                }
                .font(.headline)
                .foregroundColor(.black)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(25)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
    
    private func finishEditing() {
        textOverlay.text = editedText.isEmpty ? "Text" : editedText
        isTextFieldFocused = false
        isEditing = false
    }
}

struct ColorPickerButton: View {
    let color: Color
    @Binding var selectedColor: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 40, height: 40)
            .overlay(
                Circle()
                    .stroke(selectedColor == color ? Color.white : Color.gray.opacity(0.5), 
                           lineWidth: selectedColor == color ? 3 : 1)
            )
            .onTapGesture {
                selectedColor = color
            }
    }
}

struct AlignmentButton: View {
    let alignment: TextAlignment
    @Binding var selectedAlignment: TextAlignment
    let icon: String
    
    var body: some View {
        Button(action: {
            selectedAlignment = alignment
        }) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(selectedAlignment == alignment ? .black : .white)
                .frame(width: 50, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedAlignment == alignment ? Color.white : Color.clear)
                        .stroke(Color.white, lineWidth: 1)
                )
        }
    }
}

enum FontWeightOption: CaseIterable {
    case light, regular, medium, bold, heavy
    
    var weight: Font.Weight {
        switch self {
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .bold: return .bold
        case .heavy: return .heavy
        }
    }
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        }
    }
}

#Preview {
    @Previewable @State var sampleOverlay = TextOverlay(text: "Sample Text")
    @Previewable @State var isEditing = true
    
    ZStack {
        Image(systemName: "photo")
            .font(.system(size: 100))
            .foregroundColor(.gray)
        
        if isEditing {
            InlineTextEditingView(textOverlay: $sampleOverlay, isEditing: $isEditing)
        }
    }
}