//
//  ChatBubbleView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 30/01/26.
//

//
//  ChatBubbleView.swift
//  AYUA
//
//  Updated for iOS 26+
//

import SwiftUI

//struct ChatBubbleView: View {
//
//    let message: ChatDetailModel
//    let isOpponent: Bool
//
//    var body: some View {
//        GeometryReader { geo in
//            HStack {
//                if isOpponent { Spacer() }
//
//                VStack(alignment: isOpponent ? .trailing : .leading, spacing: 4) {
//
//                    // Message bubble
//                    Text(message.strOpponentChatMessage)
//                        .padding(10)
//                        .background(isOpponent ? Color.gray.opacity(0.2) : Color.blue)
//                        .foregroundColor(isOpponent ? .black : .white)
//                        .cornerRadius(12)
//                        .fixedSize(horizontal: false, vertical: true) // allows multiline
//
//                    // Time below message
//                    Text(message.strOpponentChatTime)
//                        .font(.caption2)
//                        .foregroundColor(.gray)
//                }
//                .frame(maxWidth: geo.size.width * 0.75,
//                       alignment: isOpponent ? .trailing : .leading)
//
//                if !isOpponent { Spacer() }
//            }
//            .padding(.horizontal)
//        }
//        .frame(height: nil) // let height adjust automatically
//    }
//}
//
//// MARK: - Time Formatter
//extension String {
//    func chatTime() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // match your API date format
//        guard let date = formatter.date(from: self) else { return self }
//
//        formatter.dateFormat = "hh:mm a"
//        return formatter.string(from: date)
//    }
//}


struct ChatBubbleView: View {
    let message: ChatDetailModel
    let isOpponent: Bool

    var body: some View {
        HStack {
            if isOpponent {
                // OPPONENT (YOU) - LEFT SIDE
                Spacer()
            }
            
            VStack(alignment: isOpponent ? .trailing : .leading, spacing: 2) {
                Text(message.strOpponentChatMessage)
                    .padding(12)
                    .background(isOpponent ? Color.gray.opacity(0.2) : Color.blue)
                    .foregroundColor(isOpponent ? .primary : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .frame(maxWidth: 280, alignment: isOpponent ? .trailing : .leading)
                
                Text(message.strOpponentChatTime)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !isOpponent {
                // ME - RIGHT SIDE
                Spacer()
            }
        }
    }
}
