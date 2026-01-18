//
//  LoginViewController.swift
//  LinkSkill
//
//  Created by Rohit Singh Dhakad  [C] on 03/10/25.
//


import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    var strType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.strType == UserInfoType.User.rawValue{
            self.tfMobile.text = "8871179252"
            self.tfPassword.text = "12345"
        }else{
            self.tfMobile.text = "8839902727"
            self.tfPassword.text = "12345"
        }
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnShowhidePassword(_ sender: UIButton) {
        sender.isSelected.toggle() // toggle the button state
        
        tfPassword.isSecureTextEntry.toggle() // toggle secure entry
        
        // Maintain cursor position after toggling
        if let existingText = tfPassword.text, tfPassword.isSecureTextEntry {
            tfPassword.deleteBackward()
            tfPassword.insertText(existingText)
        }
        
    }
    
    @IBAction func btnOnforgetPassword(_ sender: Any) {
        pushVc(viewConterlerId: "ForgetPasswordViewController")
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
      
        guard let password = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty else {
            showAlert(message: "please_enter_password")
            return
        }
        

        self.call_Websercice_Login()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "alert_title".localized(),
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
  
    
    @IBAction func btnOnSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        vc.strType = self.strType
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController {
    
    func call_Websercice_Login() {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = ["mobile": self.tfMobile.text!,
                         "password": self.tfPassword.text!,
                         "device_type": "iOS",
                         "register_id": objAppShareData.strFirebaseToken,
                         "type":self.strType,
                         "language":objAppShareData.currentLanguage]as [String:Any]
        print(dictParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_LogIn, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let resultArray = response["result"] as? [String: Any] {
                    
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: resultArray)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    UserSession.shared.isLoggedIn = true
                    if objAppShareData.UserDetail.type == "User"{
                        self.setRootController()
                    }else{
                        self.setRootControllerEmployer()
                    }
                    
                    
                }
            }else{
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            print("Error \(error)")
            
            
        }
    }
    
    func setRootController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navController = UINavigationController(rootViewController: homeViewController)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
    func setRootControllerEmployer() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "UserHomeViewController") as! UserHomeViewController
        let navController = UINavigationController(rootViewController: homeViewController)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
    }
}

