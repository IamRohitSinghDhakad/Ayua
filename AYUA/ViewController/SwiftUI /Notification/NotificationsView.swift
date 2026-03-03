//
//  NotificationsView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 01/02/26.
//

import SwiftUI
import Combine
import Foundation

struct NotificationsView: View {
    
    @StateObject private var viewModel = NotificationsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            CustomHeaderView(
                title: "Notification",
                leftIcon: Image(.notifi),
                onLeftTap: {
                    print("Chat icon tapped")
                },
                showNotification: false,
                notificationIcon: Image(.notifi),
                onNotificationTap: {
                    print("Notification tapped")
                },
                onMenuTap: {
                    if let topVC = UIApplication.shared.topViewController() {
                        SideMenuManager.shared.showMenu(from: topVC)
                    }
                }
                
            )
            
            ZStack {
                
                // Always present
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.notifications) { item in
                            NotificationCardView(item: item)
                        }
                    }
                    .padding()
                }
                
                // Loader overlay (no layout shift)
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                }
            }
        }
        .onAppear {
            viewModel.fetchNotifications()
        }
    }
}

#Preview {
    NotificationsView()
}
