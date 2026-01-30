//
//  DetailChatView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 30/01/26.
//
import SwiftUI
import Combine
import Foundation

struct DetailChatView: View {
    @StateObject var viewModel: ChatDetailViewModel
    let username: String
    
    @State private var showReportConfirm = false
    @State private var showReportSheet = false
    @State private var hasInitialScrollCompleted = false 
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ChatHeaderView(
                username: username,
                onBlockUser: { viewModel.blockUser() },
                onShowReportSheet: { showReportConfirm = true },
                onDeleteChat: { viewModel.deleteChat() }
            )
            
            // Chat Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.messages, id: \.strMsgIDForDelete) { message in
                            ChatBubbleView(
                                message: message,
                                isOpponent: message.strSenderId == objAppShareData.UserDetail.strUserId ?? ""
                            )
                        }
                        Color.clear.frame(height: 0.1).id("scroll-bottom")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                // ✅ SCROLL ONLY ON INITIAL LOAD
                .onReceive(viewModel.$messages.first()) { firstMessage in
                    // Scroll ONLY if:
                    // 1. First time loading (hasInitialScrollCompleted = false)
                    // 2. Messages array has content
                    if !hasInitialScrollCompleted && !viewModel.messages.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeOut(duration: 0.4)) {
                                proxy.scrollTo("scroll-bottom", anchor: .bottom)
                            }
                            hasInitialScrollCompleted = true  // Disable future scrolls
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Input
            if !viewModel.showBlockedView {
                MessageInputView(
                    text: $viewModel.messageText,
                    onSend: viewModel.sendMessage,
                    onAttachmentTap: nil,
                    showAttachmentButton: false
                )
            } else {
                Color.clear.frame(height: 0)
            }
        }
        .confirmationDialog("Report User", isPresented: $showReportConfirm) {
            Button("Report User", role: .destructive) { showReportSheet = true }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will notify administrators about this user. This can't be undone.")
        }
        .sheet(isPresented: $showReportSheet) {
            ReportUserSheet(
                onSubmit: { reason in
                    viewModel.reportUser(reason: reason)
                    showReportSheet = false
                },
                onCancel: { showReportSheet = false }
            )
        }
        .onAppear {
            viewModel.onAppear()
            // Reset scroll flag when entering chat
            hasInitialScrollCompleted = false
        }
        .onDisappear {
            viewModel.onDisappear()
            // Reset for next chat
            hasInitialScrollCompleted = false
        }
        .alert("Chat Blocked", isPresented: $viewModel.showBlockedView) {
            Button("OK") { }
        } message: {
            Text(viewModel.isBlocked ? "You have been blocked" : "You blocked this user")
        }
    }
}
