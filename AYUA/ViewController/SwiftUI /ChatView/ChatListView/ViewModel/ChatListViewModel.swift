//
//  ChatListViewModel.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 31/01/26.
//

import Foundation
import SwiftUI
import Combine

final class ChatListViewModel: ObservableObject {

    @Published var userList: [StoreModel] = []
    @Published var isLoading = false
    @Published var showDeleteAlert = false
    @Published var selectedChat: StoreModel?

    // MARK: - API Call
    func fetchChatList() {
        guard objWebServiceManager.isNetworkAvailable() else {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: UIApplication.shared.topViewController()!)
            return
        }

        isLoading = true

        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUserId ?? "",
            "language": objAppShareData.currentLanguage
        ]

        objWebServiceManager.requestPost(
            strURL: WsUrl.url_GetConversation,
            queryParams: [:],
            params: params,
            strCustomValidation: "",
            showIndicator: false
        ) { response in
            DispatchQueue.main.async {
                self.isLoading = false
                self.userList.removeAll()

                if let data = response["result"] as? [[String: Any]] {
                    self.userList = data.map { StoreModel(from: $0) }
                }
            }
        } failure: { _ in
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

    // MARK: - Delete Conversation
    func deleteConversation(chat: StoreModel) {
        let params: [String: Any] = [
            "sender_id": chat.sender_id ?? "",
            "receiver_id": chat.receiver_id ?? "",
            "product_id": chat.job_id ?? "",
            "delete_conversation": "1"
        ]

        objWebServiceManager.requestGet(
            strURL: WsUrl.url_clearConversation,
            params: params,
            queryParams: [:],
            strCustomValidation: ""
        ) { _ in
            DispatchQueue.main.async {
                self.fetchChatList()
            }
        } failure: { _ in }
    }
}
