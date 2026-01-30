//
//  ReportUserSheet.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 30/01/26.
//

import Foundation
import SwiftUI

struct ReportUserSheet: View {
    let onSubmit: (String) -> Void
    let onCancel: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedReason = ""
    @State private var customReason = ""
    
    let reasons = [
        "Inappropriate content",
        "Harassment or bullying",
        "Spam or fake account",
        "Other"
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Why are you reporting this user?")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Your report will be anonymous.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(reasons, id: \.self) { reason in
                        Button {
                            selectedReason = reason
                        } label: {
                            HStack {
                                Image(systemName: selectedReason == reason ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selectedReason == reason ? .blue : .secondary)
                                
                                Text(reason)
                                    .font(.body)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // Custom reason (HIG: Provide text input)
                if selectedReason == "Other" {
                    VStack(alignment: .leading) {
                        Text("Describe the issue")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        TextEditor(text: $customReason)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 80)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.trailing, 8)
                    }
                }
                
                Spacer()
            }
            .padding()
            .presentationDetents([.medium, .large], selection: .constant(.medium))  // HIG: Bottom sheet
            .navigationTitle("Report User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Submit") {
                            let reason = selectedReason == "Other" ? customReason : selectedReason
                            onSubmit(reason)  // ✅ Passes reason
                        }
                    .disabled(selectedReason.isEmpty)
                    .tint(.blue)
                }
            }
        }
    }
}

