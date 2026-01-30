//
//  ChatHeaderView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 31/01/26.
//

import SwiftUI

struct CustomHeaderView: View {

    // MARK: - Config
    let title: String

    var backgroundColor: Color = Color(.background)

    var leftIcon: Image?
    var onLeftTap: (() -> Void)?

    var showNotification: Bool = false
    var notificationIcon: Image = Image(.notifi)
    var onNotificationTap: (() -> Void)?

    var showMenu: Bool = true
    var menuIcon: Image = Image(.menu)
    var onMenuTap: (() -> Void)?

    // MARK: - UI
    var body: some View {
        HStack(spacing: 12) {

            // Left Button
            if let leftIcon {
                Button {
                    onLeftTap?()
                } label: {
                    leftIcon
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            }

            Spacer()

            // Title
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)

            Spacer()

            // Notification Button
            if showNotification {
                Button {
                    onNotificationTap?()
                } label: {
                    notificationIcon
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            }

            // Menu Button
            if showMenu {
                Button {
                    onMenuTap?()
                } label: {
                    menuIcon
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(backgroundColor)
        .overlay(
            Divider(),
            alignment: .bottom
        )
    }
}
