//
//  SideMenuManager.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import Foundation
import UIKit

struct MenuItem {
    let title: String
    let storyboardID: String?   // Optional VC identifier
    let iconInactive: String?   // Optional image name
    let iconActive: String?     // Optional image name
}

class SideMenuManager {

    static let shared = SideMenuManager()
    private init() {
        setupDefaultMenu()
    }

    private var menuItems: [MenuItem] = []
    private var viewControllerCache: [String: UIViewController] = [:]

    // MARK: - Default Menu Setup
    
    private func setupDefaultMenu() {

        guard let userType = UserSession.shared.userType else {
            menuItems = []
            return
        }

        switch userType {

        case .User:
            menuItems = userMenuItems()

        case .Provider:
            menuItems = providerMenuItems()
        }
    }
    
    private func userMenuItems() -> [MenuItem] {
        return [
            MenuItem(title: "HOME", storyboardID: "HomeViewController", iconInactive: "HOME", iconActive: "HOME"),
            MenuItem(title: "CHAT", storyboardID: "ChatViewController", iconInactive: "CHAT", iconActive: "CHAT"),
            MenuItem(title: "HISTORY", storyboardID: "HistoryViewController", iconInactive: "HISTORY", iconActive: "HISTORY"),
            MenuItem(title: "MY ACCOUNT", storyboardID: "MyAccountViewController", iconInactive: "MY ACCOUNT", iconActive: "MY ACCOUNT"),
            MenuItem(title: "My REVIEWS".localized(), storyboardID: "MyReviewsViewController", iconInactive: "REVIEW", iconActive: "REVIEW"),
            MenuItem(title: "LANGUAGE".localized(), storyboardID: "LanguageViewController", iconInactive: "language", iconActive: "language"),
            MenuItem(title: "PRIVACY POLICY", storyboardID: "PrivacyPolicyViewController", iconInactive: "PRIVACY", iconActive: "PRIVACY"),
            MenuItem(title: "TERMS & CONDITIONS", storyboardID: "PrivacyPolicyViewController", iconInactive: "terms", iconActive: "terms"),
            MenuItem(title: "LOGOUT", storyboardID: nil, iconInactive: "logout", iconActive: "logout")
        ]
    }

    private func providerMenuItems() -> [MenuItem] {
        return [
            MenuItem(title: "HOME", storyboardID: "UserHomeViewController", iconInactive: "HOME", iconActive: "HOME"),
            MenuItem(title: "CHAT", storyboardID: "ChatViewController", iconInactive: "CHAT", iconActive: "CHAT"),
            MenuItem(title: "HISTORY", storyboardID: "UsersHistoryViewController", iconInactive: "HISTORY", iconActive: "HISTORY"),
            MenuItem(title: "MY ACCOUNT", storyboardID: "MyAccountViewController", iconInactive: "MY ACCOUNT", iconActive: "MY ACCOUNT"),
            MenuItem(title: "MEMBERSHIP", storyboardID: "MyAccountViewController", iconInactive: "MY ACCOUNT", iconActive: "MY ACCOUNT"),
            MenuItem(title: "My REVIEWS".localized(), storyboardID: "MyReviewsViewController", iconInactive: "REVIEW", iconActive: "REVIEW"),
            MenuItem(title: "LANGUAGE".localized(), storyboardID: "LanguageViewController", iconInactive: "language", iconActive: "language"),
            MenuItem(title: "PRIVACY POLICY", storyboardID: "PrivacyPolicyViewController", iconInactive: "PRIVACY", iconActive: "PRIVACY"),
            MenuItem(title: "TERMS & CONDITIONS", storyboardID: "PrivacyPolicyViewController", iconInactive: "terms", iconActive: "terms"),
            MenuItem(title: "LOGOUT", storyboardID: nil, iconInactive: "logout", iconActive: "logout")
        ]
    }

    // MARK: - Show Side Menu
    func showMenu(from parent: UIViewController, widthFactor: CGFloat = 0.7) {
        setupDefaultMenu()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sideMenuVC = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController else {
            print("⚠️ Could not find SideMenuViewController")
            return
        }

        sideMenuVC.menuItems = menuItems
        sideMenuVC.onMenuItemSelected = { [weak self] item in
            self?.handleMenuSelection(item, from: parent)
        }

        // Container + dimmed background
        let containerVC = UIViewController()
        containerVC.modalPresentationStyle = .overCurrentContext
        containerVC.view.backgroundColor = .clear

        let dimmedView = UIView(frame: parent.view.bounds)
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmedView.alpha = 0
        containerVC.view.addSubview(dimmedView)

        let tapGesture = UITapGestureRecognizer(target: containerVC, action: #selector(containerVC.dismissSelf))
        dimmedView.addGestureRecognizer(tapGesture)

        containerVC.addChild(sideMenuVC)
        containerVC.view.addSubview(sideMenuVC.view)
        sideMenuVC.didMove(toParent: containerVC)

        let menuWidth = parent.view.frame.width * widthFactor
        //From Left To Right
//        sideMenuVC.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: parent.view.frame.height)
//
//        parent.present(containerVC, animated: false) {
//            UIView.animate(withDuration: 0.3) {
//                sideMenuVC.view.frame.origin.x = 0
//                dimmedView.alpha = 1
//            }
//        }
        
        //From Right To Left
        sideMenuVC.view.frame = CGRect(
            x: parent.view.frame.width,
            y: 0,
            width: menuWidth,
            height: parent.view.frame.height
        )

        parent.present(containerVC, animated: false) {
            UIView.animate(withDuration: 0.3) {
                sideMenuVC.view.frame.origin.x = parent.view.frame.width - menuWidth
                dimmedView.alpha = 1
            }
        }
    }

    // MARK: - Handle Menu Selection
    private func handleMenuSelection(_ item: MenuItem, from parent: UIViewController) {

        if item.title == "LOGOUT" {
            showLogoutConfirmation(from: parent)
            return
        }

        guard let storyboardID = item.storyboardID else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardID)

        // 🔥 Handle Privacy & Terms
        if let legalVC = vc as? PrivacyPolicyViewController {
            if item.title == "PRIVACY POLICY" {
                legalVC.pageType = .privacy
            } else if item.title == "TERMS & CONDITIONS" {
                legalVC.pageType = .terms
            }
        }

        if let nav = parent.navigationController {
            if let topVC = nav.topViewController,
               type(of: topVC) == type(of: vc) {
                print("⚠️ Already on \(storyboardID), skipping push")
                return
            }
            nav.pushViewController(vc, animated: true)
        } else {
            parent.present(vc, animated: true)
        }
    }

//    private func handleMenuSelection(_ item: MenuItem, from parent: UIViewController) {
//
//        if item.title == "Logout" {
//            showLogoutConfirmation(from: parent)
//            return
//        }
//
//        guard let storyboardID = item.storyboardID else { return }
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: storyboardID)
//
//        if let nav = parent.navigationController {
//            // ✅ Prevent pushing same controller again
//            if let topVC = nav.topViewController,
//               type(of: topVC) == type(of: vc) {
//                print("⚠️ Already on \(storyboardID), skipping push")
//                return
//            }
//            nav.pushViewController(vc, animated: true)
//        } else {
//            parent.present(vc, animated: true)
//        }
//    }


    // MARK: - Logout Confirmation
    private func showLogoutConfirmation(from parent: UIViewController) {
        let alert = UIAlertController(title: "Logout",
                                      message: "Are you sure you want to logout?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.performLogout(from: parent)
        })
        parent.present(alert, animated: true)
    }

    private func performLogout(from parent: UIViewController) {
       
    }
}

