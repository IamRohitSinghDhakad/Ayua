//
//  ContactUsViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 08/01/26.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet weak var tfSubject: UITextField!
    @IBOutlet weak var txtVwMsg: UITextView!
    
    var isComingFrom : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.lblHeading.applyStyle(AppFonts.title)
    }
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        SideMenuManager.shared.showMenu(from: self)
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        // Trim whitespaces to prevent empty-space submissions
           let email = tfSubject.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
           let message = txtVwMsg.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
           
           // Validate email field
           guard !email.isEmpty else {
               objAlert.showAlert(message: "Please enter subject", title: "Alert", controller: self)
               return
           }
           
           // Validate message field
           guard !message.isEmpty else {
               objAlert.showAlert(message: "Please enter your message.", title: "Alert", controller: self)
               return
           }
           
           // ✅ All validations passed — proceed with submission
           print("Subject: \(email)")
           print("Message: \(message)")
           
        self.call_WebService_ContactUs(strSubject: email, strDescription: message)
    }
    
    @IBAction func btnOnWhatsapp(_ sender: Any) {
        let phoneNumber = "7999722203" 
           let message = "Hello"

           let appURLString = "whatsapp://send?phone=\(phoneNumber)&text=\(message)"
           let webURLString = "https://wa.me/\(phoneNumber)?text=\(message)"

           guard
               let encodedAppURL = appURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let encodedWebURL = webURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let appURL = URL(string: encodedAppURL),
               let webURL = URL(string: encodedWebURL)
           else { return }

           if UIApplication.shared.canOpenURL(appURL) {
               UIApplication.shared.open(appURL)
           } else {
               UIApplication.shared.open(webURL)
           }
    }
}


extension ContactUsViewController{
  
    func call_WebService_ContactUs(strSubject: String, strDescription:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
        }
        
        objWebServiceManager.showIndicator()
        
        var dictParam = [:] as [String:Any]
        
        if self.isComingFrom == "Employee"{
            dictParam = [
                "employee_id": objAppShareData.UserDetail.strUserId!,
                "subject": strSubject,
                "message": strDescription,
                "language": objAppShareData.currentLanguage]as [String:Any]
        }else{
            dictParam = [
                "user_id": objAppShareData.UserDetail.strUserId!,
                "subject": strSubject,
                "message": strDescription,
                "lang": objAppShareData.currentLanguage]as [String:Any]
        }
        print(dictParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_contact_us, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode{
                if let resultArray = response["result"] as? [String: Any] {
                   
                    objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "Success", message: message ?? "", controller: self) {
                        self.setRootController()
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
    
}
    
