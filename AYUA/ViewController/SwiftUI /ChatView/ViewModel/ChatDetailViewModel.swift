//
//  ChatDetailViewModel.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 30/01/26.
//

import Foundation
import SwiftUI
import Combine

final class ChatDetailViewModel: ObservableObject {

    // MARK: - Published (UI State)
    @Published var messages: [ChatDetailModel] = []
    @Published var messageText: String = ""
    @Published var isBlocked: Bool = false
    @Published var showBlockedView: Bool = false
    @Published var showImagePreview: Bool = false
    @Published var selectedImageURL: URL?
    @Published var messagesLoaded = false  // Add this line
    @Published var hasLoadedMessages = false  // ← NEW



    // MARK: - IDs
    let senderId: String      // My ID
    let receiverId: String    // Opponent ID
    let jobId: String

    // MARK: - Internal
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(senderId: String, receiverId: String, jobId: String) {
        self.senderId = senderId
        self.receiverId = receiverId
        self.jobId = jobId
    }

    // MARK: - Lifecycle
    func onAppear() {
        call_GetProfile()
    }

    func onDisappear() {
        stopTimer()
    }

    // MARK: - Timer
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            self?.call_GetChat()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - UI Helpers
    func openImage(url: String) {
        guard let url = URL(string: url) else { return }
        selectedImageURL = url
        showImagePreview = true
    }
    
    // In ChatDetailViewModel
    func blockUser() {
        // Your block API call
        print("🚫 Block user tapped")
    }

    func reportUser(reason: String) {
        // Your report API call
        print("⚠️ Report user tapped with reason", reason)
    }

    func deleteChat() {
        // Your delete chat API call
        print("🗑️ Delete chat tapped")
    }

}

extension ChatDetailViewModel {

    func call_GetProfile() {
        let parameter: [String: Any] = [
            "login_user_id": objAppShareData.UserDetail.strUserId ?? "",
            "language": objAppShareData.currentLanguage
        ]

        objWebServiceManager.requestPost(
            strURL: WsUrl.url_getUserProfile,
            queryParams: [:],
            params: parameter,
            strCustomValidation: "",
            showIndicator: false
        ) { [weak self] response in
            guard let self = self else { return }

            let status = response["status"] as? Int
            if status == MessageConstant.k_StatusCode,
               let userDetails = response["result"] as? [String: Any] {

                var blocked = ""
                var blockedByYou = ""

                if let val = userDetails["blocked"] {
                    blocked = "\(val)"
                }
                if let val = userDetails["blockedByYou"] {
                    blockedByYou = "\(val)"
                }

                DispatchQueue.main.async {
                    if blockedByYou == "1" {
                        self.showBlockedView = true
                        self.isBlocked = false
                    } else if blocked == "1" {
                        self.showBlockedView = true
                        self.isBlocked = true
                    } else {
                        self.showBlockedView = false
                        self.isBlocked = false
                        self.startTimer()
                    }
                }
            }
        } failure: { _ in }
    }
}

extension ChatDetailViewModel {

    func call_GetChat() {
        guard objWebServiceManager.isNetworkAvailable() else { return }

        let params: [String: Any] = [
            "receiver_id": receiverId,
            "sender_id": senderId,
            "job_id": jobId,
            "lang": objAppShareData.currentLanguage
        ]

        print(params)
        
        objWebServiceManager.requestPost(
            strURL: WsUrl.url_GetChat,
            queryParams: [:],
            params: params,
            strCustomValidation: "",
            showIndicator: false
        ) { [weak self] response in
            guard let self = self,
                  let status = response["status"] as? Int,
                  status == MessageConstant.k_StatusCode,
                  let arrData = response["result"] as? [[String: Any]] else {
                return
            }

            let newMessages = arrData.compactMap { ChatDetailModel(dict: $0) }
            
            // Fixed sorting - explicit closure parameters
            let sortedMessages = newMessages.sorted { $0.strMsgIDForDelete < $1.strMsgIDForDelete }
            
            DispatchQueue.main.async {
                self.messages = sortedMessages  // Your existing line
                self.hasLoadedMessages = true  // ← ADD THIS

            }

        } failure: { _ in }
    }

}

extension ChatDetailViewModel {

    func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let params: [String: Any] = [
            "receiver_id": senderId,
            "sender_id": receiverId, 
            "job_id": jobId,
            "language": objAppShareData.currentLanguage,
            "chat_message": text
        ]

        objWebServiceManager.requestPost(
            strURL: WsUrl.url_InsertChat,
            queryParams: [:],
            params: params,
            strCustomValidation: "",
            showIndicator: false
        ) { [weak self] response in
            guard let self = self else { return }
            
            if let result = response["result"] as? String, result == "successful" {
                DispatchQueue.main.async {
                    self.messageText = ""
                    // Immediately refresh to show sent message
                    self.call_GetChat()
                }
            }
        } failure: { _ in }
    }
}

extension ChatDetailViewModel {

    func deleteMessage(_ message: ChatDetailModel) {
        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUserId ?? "",  // Fixed: Use logged-in user ID
            "chat_id": message.strMsgIDForDelete
        ]

        objWebServiceManager.requestPost(
            strURL: WsUrl.url_deleteChatSingleMessage,
            queryParams: [:],
            params: params,
            strCustomValidation: "",
            showIndicator: false
        ) { [weak self] response in
            guard let self = self,
                  let status = response["status"] as? Int,
                  status == MessageConstant.k_StatusCode else {
                return
            }
            
            DispatchQueue.main.async {
                // Refresh messages after delete
                self.call_GetChat()
            }
        } failure: { _ in }
    }
}
