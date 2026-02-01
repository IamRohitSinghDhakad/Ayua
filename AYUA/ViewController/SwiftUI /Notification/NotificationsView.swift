//
//  NotificationsView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 01/02/26.
//

//
//  NotificationsView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 01/02/26.
//

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

    // ✅ Correct ownership
    @StateObject private var viewModel = NotificationsViewModel()

    var body: some View {
        VStack(spacing: 0) {

            CustomHeaderView(
                title: "Notification",
                leftIcon: Image(.notifi),
                onLeftTap: {
                    print("Chat icon tapped")
                },
                showNotification: true,
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
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.notifications) { item in
                            NotificationCardView(
                                item: item,
                                onReject: {
                                   // viewModel.rejectNotification(item)
                                },
                                onReview: {
                                    //viewModel.reviewNotification(item)
                                }
                            )
                        }
                    }
                    .padding()
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
