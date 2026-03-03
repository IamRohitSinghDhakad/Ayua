//
//  NotificationCardView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 01/02/26.
//

import SwiftUI
import Combine


import SwiftUI

struct NotificationCardView: View {
    
    let item: NotificationModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            // Left - Static Notification Image
            Image(systemName: "bell.fill") // You can replace with Image(.notificationIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            // Center - Notification Text
            VStack(alignment: .leading, spacing: 4) {
                
                Text(item.title ?? "Notification Title")
                    .font(.headline)
                
                Text(item.title ?? "Notification message goes here.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Right - Date & Time
            VStack(alignment: .trailing, spacing: 4) {
                
                Text("18 Feb 2026")
                    .font(.caption)
                    .foregroundColor(.gray)

            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
   // NotificationCardView(item: NotificationModel(from: [:]), onReject: { }, onReview: { })
}
