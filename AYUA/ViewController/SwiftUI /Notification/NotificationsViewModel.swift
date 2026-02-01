//
//  NotificationsViewModel.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 01/02/26.
//


//
//  NotificationsViewModel.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 01/02/26.
//

import Foundation
import SwiftUI
import Combine

final class NotificationsViewModel: ObservableObject {

    @Published var notifications: [NotificationModel] = []
    @Published var isLoading = false

    // MARK: - Fetch Notifications
    func fetchNotifications() {

        guard objWebServiceManager.isNetworkAvailable() else {
            objAlert.showAlert(
                message: "No Internet Connection",
                title: "Alert",
                controller: UIApplication.shared.topViewController()!
            )
            return
        }

        isLoading = true

        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUserId ?? "",
            "language": objAppShareData.currentLanguage
        ]

        objWebServiceManager.requestPost(
            strURL: WsUrl.url_GetNotification,
            queryParams: [:],
            params: params,
            strCustomValidation: "",
            showIndicator: false
        ) { response in

            DispatchQueue.main.async {
                self.isLoading = false
                self.notifications.removeAll()

                if let data = response["result"] as? [[String: Any]] {
                    self.notifications = data.map {
                        NotificationModel(from: $0)
                    }
                }
            }

        } failure: { _ in
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

//    // MARK: - Reject Notification
//    func rejectNotification(_ notification: NotificationModel) {
//
//        let params: [String: Any] = [
//            "notification_id": notification.id ?? "",
//            "user_id": objAppShareData.UserDetail.strUserId ?? ""
//        ]
//
//        objWebServiceManager.requestPost(
//            strURL: WsUrl.url_rejectNotification,
//            queryParams: [:],
//            params: params,
//            strCustomValidation: "",
//            showIndicator: false
//        ) { _ in
//            DispatchQueue.main.async {
//                self.notifications.removeAll { $0.id == notification.id }
//            }
//        } failure: { _ in }
//    }
//
//    // MARK: - Review Notification
//    func reviewNotification(_ notification: NotificationModel) {
//        // Navigation or review API call
//    }
}
