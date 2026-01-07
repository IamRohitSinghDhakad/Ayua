//
//  WelcomeScreenViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 05/01/26.
//

import UIKit
enum UserInfoType: String {
    case User
    case Provider
}

class WelcomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnSerchForHelp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.strType = UserInfoType.User.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOnToOfferMyService(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.strType = UserInfoType.Provider.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }

   
}
