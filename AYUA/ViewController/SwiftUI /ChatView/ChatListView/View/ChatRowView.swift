//
//  ChatRowView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 31/01/26.
//

import SwiftUI
import SDWebImage

struct ChatRowView: View {

    let chat: StoreModel
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            AvatarImage(
                urlString: chat.sender_image,
                size: 50
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(chat.sender_name ?? "")
                    .font(.system(size: 16, weight: .semibold))

                Text(lastMessageText)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer()

            Text(chat.time_ago ?? "")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete Chat", systemImage: "trash")
            }
        }
    }


    private var lastMessageText: String {
        if let msg = chat.last_message, !msg.isEmpty {
            return msg
        } else if let img = chat.last_image, !img.isEmpty {
            return "📷 Image"
        } else {
            return "📎 File"
        }
    }
}
