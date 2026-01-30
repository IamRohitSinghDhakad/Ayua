//
//  ChatHeaderView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 30/01/26.
//

import Foundation
import SwiftUI

struct ChatHeaderView: View {
    let username: String
    @Environment(\.dismiss) private var dismiss
    
    let onBlockUser: () -> Void
    let onShowReportSheet: () -> Void  // NEW: Report callback
    let onDeleteChat: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 44, height: 44)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(username)
                        .font(.headline)
                        .fontWeight(.semibold)
//                    Text("Online")
//                        .font(.caption2)
//                        .foregroundStyle(.green.opacity(0.8))
                }
                
                Spacer()
                
                Menu {
                    Button("Block User", role: .destructive) { onBlockUser() }
                    Button("Report User") { onShowReportSheet() }  // ✅ HIG: Non-destructive first
                    Divider()
                    Button("Delete Chat", role: .destructive) { onDeleteChat() }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider().padding(.horizontal, 16)
        }
        .background(Color(.systemBackground))
    }
}

