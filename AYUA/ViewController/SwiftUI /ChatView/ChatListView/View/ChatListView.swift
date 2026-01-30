//
//  ChatListView.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 31/01/26.
//

import SwiftUI

struct ChatListView: View {

    @StateObject private var viewModel = ChatListViewModel()

    var body: some View {
        VStack(spacing: 0) {

            CustomHeaderView(
                title: "Chat",
                leftIcon: Image(.CHAT),
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


            List {
                ForEach(viewModel.userList, id: \.sender_id) { chat in
                    ChatRowView(chat: chat) {
                        viewModel.selectedChat = chat
                        viewModel.showDeleteAlert = true
                    }
                    .onTapGesture {
                        openChatDetail(chat)
                    }
                    .listRowBackground(Color(.background))
                }
            }
            .listStyle(.plain)
            .background(Color(.background))
        }
       // .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchChatList()
        }
        .alert("Delete Chat?",
               isPresented: $viewModel.showDeleteAlert) {

            Button("Yes", role: .destructive) {
                if let chat = viewModel.selectedChat {
                    viewModel.deleteConversation(chat: chat)
                }
            }

            Button("No", role: .cancel) {}

        } message: {
            Text("Are you sure you want to delete chat history with this user?")
        }
        
    }

    // MARK: - Navigation
    private func openChatDetail(_ chat: StoreModel) {

        let vm = ChatDetailViewModel(
            senderId: chat.sender_id ?? "",
            receiverId: chat.receiver_id ?? "",
            jobId: chat.job_id ?? ""
        )

        vm.isBlocked = chat.strBlocked.boolValue

        let detailView = DetailChatView(
            viewModel: vm,
            username: chat.sender_name ?? ""
        )

        let hostingVC = UIHostingController(rootView: detailView)

        UIApplication.shared.topViewController()?
            .navigationController?
            .pushViewController(hostingVC, animated: true)
    }
}


extension UIApplication {
    func topViewController(
        base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
    ) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
