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
    @IBOutlet weak var tfProfession: MultiSelectDropDown!
    
    
    // MARK: - Data Source
       var arrCategory: [String] = []
       var arrCategoryID: [Int] = []

       var arrSubCategory: [String] = []
       var arrSubCategoryID: [Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwProfession.isHidden = true
        self.vwServiceType.isHidden = true

        self.tfServiceType.delegate = self
        self.tfProfession.delegate = self
        
        self.tfServiceType.isSearchEnable = false
        
       // self.tfProfession.isSearchEnable = false
        
        setupDropDowns()
        self.call_WebService_GetCategory()

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

extension MyAccountViewController {

    func setupDropDowns() {

        tfServiceType.didSelect { [weak self] selectedText, index, id in
            guard let self else { return }

            let categoryID = self.arrCategoryID[index]

            // Reset profession dropdown completely
            self.tfProfession.text = ""
            self.tfProfession.optionArray = []
            self.tfProfession.optionIds = []
            self.tfProfession.reloadData()

            self.call_WebService_GetSubCategory(
                strSelectedCategoryID: "\(categoryID)"
            )
        }
        
        tfProfession.selectionMode = .single

        
        tfProfession.didSelectCompletion = { names, ids in
            print(names)
            print(ids)
        }
        
    }

}


extension MyAccountViewController {

    func call_Websercice_GetProfile() {

        guard objWebServiceManager.isNetworkAvailable() else {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }

        objWebServiceManager.showIndicator()

        let dictParam: [String: Any] = [
            "login_user_id": objAppShareData.UserDetail.strUserId ?? "",
            "lang": objAppShareData.currentLanguage
        ]

        objWebServiceManager.requestPost(
            strURL: WsUrl.url_getUserProfile,
            queryParams: [:],
            params: dictParam,
            strCustomValidation: "",
            showIndicator: false
        ) { response in

            objWebServiceManager.hideIndicator()

            if response["status"] as? Int == MessageConstant.k_StatusCode,
               let result = response["result"] as? [String: Any] {

                let obj = UserModel(from: result)

                self.imgVwUser.sd_setImage(
                    with: URL(string: obj.userImage ?? ""),
                    placeholderImage: UIImage(named: "logo")
                )

                self.tfName.text = obj.name
                self.tfMobileNumber.text = obj.mobile
                self.tfPassword.text = obj.password
                self.tfPassword.isSecureTextEntry = true

                if obj.type == "Provider" {
                    self.vwProfession.isHidden = false
                    self.vwServiceType.isHidden = false
                    self.tfServiceType.text = obj.category
                    self.tfProfession.text = obj.subCategory
                }
            } else {
                objAlert.showAlert(
                    message: response["message"] as? String ?? "",
                    title: "Alert",
                    controller: self
                )
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            print("❌ Error:", error)
        }
    }
}


extension MyAccountViewController {

    func call_WebService_GetCategory() {

        guard objWebServiceManager.isNetworkAvailable() else {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }

        objWebServiceManager.showIndicator()

        let dictParam: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUserId ?? "",
            "lang": objAppShareData.currentLanguage
        ]

        objWebServiceManager.requestPost(
            strURL: WsUrl.url_getCategory,
            queryParams: [:],
            params: dictParam,
            strCustomValidation: "",
            showIndicator: false
        ) { response in

            objWebServiceManager.hideIndicator()

            if response["status"] as? Int == MessageConstant.k_StatusCode,
               let resultArray = response["result"] as? [[String: Any]] {

                self.arrCategory.removeAll()
                self.arrCategoryID.removeAll()

                for dict in resultArray {
                    let model = CategoryModel(from: dict)
                    self.arrCategory.append(model.name ?? "")
                    let id = Int(model.id ?? "") ?? 0
                    self.arrCategoryID.append(id)

                }

                self.tfServiceType.optionArray = self.arrCategory

                if let firstID = self.arrCategoryID.first {
                    self.call_WebService_GetSubCategory(strSelectedCategoryID: "\(firstID)")
                }

            } else {
                objAlert.showAlert(
                    message: response["message"] as? String ?? "Something went wrong",
                    title: "Alert",
                    controller: self
                )
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            print("❌ Error:", error)
        }
    }
}


extension MyAccountViewController {

    func call_WebService_GetSubCategory(strSelectedCategoryID: String) {

        guard objWebServiceManager.isNetworkAvailable() else {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }

        let dictParam: [String: Any] = [
            "category_id": strSelectedCategoryID,
            "lang": objAppShareData.currentLanguage
        ]

        objWebServiceManager.requestPost(
            strURL: WsUrl.url_getSubCategory,
            queryParams: [:],
            params: dictParam,
            strCustomValidation: "",
            showIndicator: false
        ) { response in

            if response["status"] as? Int == MessageConstant.k_StatusCode,
               let resultArray = response["result"] as? [[String: Any]] {

                self.arrSubCategory.removeAll()
                self.arrSubCategoryID.removeAll()

                //self.tfProfession.selectedIndex = nil
               // self.tfProfession.resetSelection()
                self.tfProfession.optionIds = self.arrSubCategoryID
                self.tfProfession.optionArray = self.arrSubCategory

                for dict in resultArray {
                    let model = SubCategoryModel(from: dict)
                    self.arrSubCategory.append(model.name ?? "")
                    let id = Int(model.id ?? "") ?? 0
                    self.arrSubCategoryID.append(id)
                }

                self.tfProfession.optionIds = self.arrSubCategoryID
                self.tfProfession.optionArray = self.arrSubCategory

            } else {
                objAlert.showAlert(
                    message: response["message"] as? String ?? "Something went wrong",
                    title: "Alert",
                    controller: self
                )
            }
        } failure: { error in
            print("❌ Error:", error)
        }
    }
}

