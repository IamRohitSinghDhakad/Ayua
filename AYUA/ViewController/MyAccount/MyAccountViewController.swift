//
//  MyAccountViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 08/01/26.
//

import UIKit
import SDWebImage

class MyAccountViewController: UIViewController {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var tfMobileNumber: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var vwServiceType: UIView!
    @IBOutlet weak var vwProfession: UIView!
    @IBOutlet weak var tfServiceType: DropDown!
    @IBOutlet weak var tfProfession: DropDown!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfServiceType.delegate = self
        self.tfProfession.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        call_Websercice_GetProfile()
    }
    

    @IBAction func btnOpenSideMenu(_ sender: Any) {
        SideMenuManager.shared.showMenu(from: self)
    }
    
    @IBAction func btnOpenImage(_ sender: Any) {
        MediaPicker.shared.pickMedia(from: self) { image, dict in
            self.imgVwUser.image = image
        }
    }
    
    @IBAction func btnOnSave(_ sender: Any) {
        
    }
}


extension MyAccountViewController{
    
    func call_Websercice_GetProfile() {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = ["login_user_id":objAppShareData.UserDetail.strUserId!,
            "lang":objAppShareData.currentLanguage]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            
            print(response)
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
           
            
            if status == MessageConstant.k_StatusCode{
                if let result = response["result"] as? [String: Any] {
                   
                    let obj = UserModel(from: result)
                    
                    self.imgVwUser.sd_setImage(with: URL(string: obj.userImage ?? ""), placeholderImage: UIImage(named: "logo"))
                    self.tfName.text = obj.name
                    self.tfMobileNumber.text = obj.mobile
                    self.tfPassword.text = obj.password
                    self.tfPassword.isSecureTextEntry = true
                    
                }
            }else{
               
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            print("Error \(error)")
            
            
        }
    }
    
}
