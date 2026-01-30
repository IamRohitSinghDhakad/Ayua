//
//  ChatListView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 30/01/26.
//

import Foundation
import SwiftUI

struct ChatDetailListView: View {

    let messages: [ChatDetailModel]
    let senderId: String
    let onImageTap: (String) -> Void
    let onDelete: (ChatDetailModel) -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(messages, id: \.strMsgIDForDelete) { message in
                        ChatBubbleView(
                            message: message,
                            isOpponent: message.strSenderId != senderId
                        )
                        .onTapGesture {
                            if message.strType == "image" {
                                onImageTap(message.strImageUrl)
                            }
                        }
                        .onLongPressGesture {
                            if message.strSenderId == senderId {
                                onDelete(message)
                            }
                        }
                        .id(message.strMsgIDForDelete)
                    }
                }
                .padding(.horizontal)
            }
            .onChange(of: messages.count) { _ in
                if let last = messages.last {
                    proxy.scrollTo(last.strMsgIDForDelete, anchor: .bottom)
                }
            }
        }
    }
}
