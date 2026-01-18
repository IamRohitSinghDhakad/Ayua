//
//  PrivacyPolicyViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 08/01/26.
//

import UIKit
import WebKit

enum LegalPageType {
    case terms
    case privacy
}

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var webVw: WKWebView!
    
    var pageType: LegalPageType = .privacy   // default

       let baseURL = BASE_URL// already exists

       override func viewDidLoad() {
           super.viewDidLoad()
           
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWebPage()
    }

       private func loadWebPage() {
           var endPoint = ""

           switch pageType {
           case .terms:
               lblHeader.text = "Terms & Conditions"
               endPoint = "terms_conditions"
           case .privacy:
               lblHeader.text = "Privacy Policy"
               endPoint = "privacy_policy"
           }

           let fullURLString = baseURL + endPoint
           if let url = URL(string: fullURLString) {
               webVw.load(URLRequest(url: url))
           }
       }
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        SideMenuManager.shared.showMenu(from: self)
    }

}
