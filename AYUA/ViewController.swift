//
//  ViewController.swift
//  AYUA
//
//  Created by Rohit SIngh Dhakad on 04/01/26.
//

import UIKit

import UIKit

class ViewController: UIViewController {
    
    
    var counter = 2
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
            print("\(counter) seconds to the end of the world")
            counter -= 1
        }else{
            self.timer?.invalidate()
            goToNextController()
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
    }
    
    //MARK: - Redirection Methods
    func goToNextController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if AppSharedData.sharedObject().isLoggedIn {
            
            if objAppShareData.UserDetail.type == "User" {
                UserSession.shared.userType = .User
                let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController)!
                let navController = UINavigationController(rootViewController: vc)
                navController.isNavigationBarHidden = true
                appDelegate.window?.rootViewController = navController
            }else {
                UserSession.shared.userType = .Provider
                let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "UserHomeViewController") as? UserHomeViewController)!
                let navController = UINavigationController(rootViewController: vc)
                navController.isNavigationBarHidden = true
                appDelegate.window?.rootViewController = navController
            }
           
          
        }
        else {
            let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "WelcomeScreenViewController") as? WelcomeScreenViewController)!
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = navController
        }
    }
}
