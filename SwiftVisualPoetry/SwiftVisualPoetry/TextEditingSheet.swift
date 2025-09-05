//
//  TextEditingSheet.swift
//  SwiftVisualPoetry
//
//  Created by Alida on 9/5/25.
//

import SwiftUI

struct TextEditingSheet: View {
    @Binding var textOverlay: TextOverlay
    @Binding var isPresented: Bool
    @State private var editedText: String
    @FocusState private var isTextFieldFocused: Bool
    
    init(textOverlay: Binding<TextOverlay>, isPresented: Binding<Bool>) {
        self._textOverlay = textOverlay
        self._isPresented = isPresented
        self._editedText = State(initialValue: textOverlay.wrappedValue.text)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Text input
                TextField("Enter your text", text: $editedText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .font(.title2)
                    .focused($isTextFieldFocused)
                    .lineLimit(3...6)
                
                // Color picker
                HStack {
                    Text("Color:")
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        ColorButton(color: .white, selectedColor: $textOverlay.color)
                        ColorButton(color: .black, selectedColor: $textOverlay.color)
                        ColorButton(color: .red, selectedColor: $textOverlay.color)
                        ColorButton(color: .blue, selectedColor: $textOverlay.color)
                        ColorButton(color: .green, selectedColor: $textOverlay.color)
                        ColorButton(color: .yellow, selectedColor: $textOverlay.color)
                        ColorButton(color: .purple, selectedColor: $textOverlay.color)
                    }
                }
                
                // Font size slider
                VStack {
                    HStack {
                        Text("Size:")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(textOverlay.fontSize))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Slider(value: $textOverlay.fontSize, in: 12...72, step: 1)
                        .accentColor(.blue)
                }
                
                // Font weight picker
                VStack {
                    HStack {
                        Text("Weight:")
                            .font(.headline)
                        Spacer()
                    }
                    
                    Picker("Font Weight", selection: $textOverlay.fontWeight) {
                        Text("Light").tag(Font.Weight.light)
                        Text("Regular").tag(Font.Weight.regular)
                        Text("Medium").tag(Font.Weight.medium)
                        Text("Bold").tag(Font.Weight.bold)
                        Text("Heavy").tag(Font.Weight.heavy)
                    }
                    .pickerStyle(.segmented)
                }
                
                // Preview
                Text(editedText.isEmpty ? "Preview" : editedText)
                    .font(.system(size: textOverlay.fontSize, weight: textOverlay.fontWeight))
                    .foregroundColor(textOverlay.color)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Edit Text")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        textOverlay.text = editedText
                        isPresented = false
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

struct ColorButton: View {
    let color: Color
    @Binding var selectedColor: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 30, height: 30)
            .overlay(
                Circle()
                    .stroke(selectedColor == color ? Color.gray : Color.clear, lineWidth: 2)
            )
            .onTapGesture {
                selectedColor = color
            }
    }
}

#Preview {
    @Previewable @State var sampleOverlay = TextOverlay(text: "Sample Text")
    @Previewable @State var isPresented = true
    
    TextEditingSheet(textOverlay: $sampleOverlay, isPresented: $isPresented)
}