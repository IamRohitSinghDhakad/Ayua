//
//  MessageInputView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 30/01/26.
//

import Foundation
import SwiftUI

struct MessageInputView: View {
    @Binding var text: String
    let onSend: () -> Void
    let onAttachmentTap: (() -> Void)?  // Optional attachment callback
    let showAttachmentButton: Bool      // Boolean to show/hide attachment
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            // 📎 ATTACHMENT BUTTON (Optional)
            if showAttachmentButton, let attachmentTap = onAttachmentTap {
                Button(action: attachmentTap) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(.systemGray))
                        .frame(width: 44, height: 44)
                }
            }
            
            // 💬 TEXT INPUT (Single line → Multi-line resize)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color(.systemGray4), lineWidth: 0.5)
                            )
                    )
                    .frame(minHeight: 44, maxHeight: 100)  // Starts small, grows to 3 lines
                    .padding(.horizontal, 16)
                    .padding(.vertical, text.isEmpty ? 14 : 12)
            }
            
            // 📤 SEND BUTTON
            Button(action: onSend) {
                Image(systemName: text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                      "paperplane" : "paperplane.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(
                        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                        Color(.systemGray) : Color(.systemBlue)
                    )
                    .frame(width: 44, height: 44)
                    .background(
                        Circle().fill(
                            text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                            Color.clear : Color(.systemBlue).opacity(0.15)
                        )
                    )
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}


struct AttachmentPickerView: View {
    let onPick: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button("Photos") {
                        onPick()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    Button("Files") {
                        onPick()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
                
                Divider()
                
                Button("Camera") {
                    onPick()
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Attach")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
