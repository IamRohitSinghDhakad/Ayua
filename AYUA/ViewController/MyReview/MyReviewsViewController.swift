//
//  MyReviewsViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 08/01/26.
//

import UIKit
import SDWebImage

class MyReviewsViewController: UIViewController {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var veRatings: FloatRatingView!
    @IBOutlet weak var lblratingCount: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    
    
    var arrReviews = [MyReviewModel]()
    var obj = EmployeeReviewModel(from: [:])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblUserName.text = objAppShareData.UserDetail.name
        self.imgVwUser.sd_setImage(with: URL(string: objAppShareData.UserDetail.userImage ?? ""), placeholderImage: UIImage(named: "logo"))
        self.veRatings.rating = Double(objAppShareData.UserDetail.rating ?? 1.0)
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        call_WebService_MyReviews()
        
    }
    

    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        SideMenuManager.shared.showMenu(from: self)
    }
}

extension MyReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewTableViewCell") as! MyReviewTableViewCell
        let obj = self.arrReviews[indexPath.row]
        cell.lblUserName.text = obj.reviewerName
        cell.lblDate.text = obj.entryDate
        cell.vwRatings.rating = Double(obj.rating ?? "0") ?? 0.0
        
        cell.imgVwUser.sd_setImage(with: URL(string: obj.reviewerImage ?? ""), placeholderImage: UIImage(named: "logo"))
        cell.lblDesc.text = obj.review
        
        return cell
    }
}

extension MyReviewsViewController {
    
    func call_WebService_MyReviews() {
        
        if !objWebServiceManager.isNetworkAvailable() {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUserId ?? "",
            "lang": objAppShareData.currentLanguage
        ]
        
        print(dictParam)
        
        objWebServiceManager.requestPost(
            strURL: WsUrl.url_get_review,
            queryParams: [:],
            params: dictParam,
            strCustomValidation: "",
            showIndicator: false
        ) { response in
            
            objWebServiceManager.hideIndicator()
            
            let status = response["status"] as? Int
            let message = response["message"] as? String
            
            if status == MessageConstant.k_StatusCode {
                
                if let responseDict = response as? [String: Any] {
                    print(responseDict)
                    
                    self.obj = EmployeeReviewModel(from: responseDict)
                    
                    self.arrReviews.removeAll()
                    
                    if let resultArray = responseDict["result"] as? [[String: Any]] {
                        for dataDict in resultArray {
                            let review = MyReviewModel(from: dataDict)
                            self.arrReviews.append(review)
                        }
                    }
                    
                    if self.arrReviews.isEmpty {
                        self.tblVw.displayBackgroundText(text: "No Reviews Available")
                    } else {
                        self.tblVw.displayBackgroundText(text: "")
                    }
                    
                    self.tblVw.reloadData()
                    
                } else {
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
                
            } else {
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
            
        } failure: { error in
            objWebServiceManager.hideIndicator()
            print("Error: \(error)")
        }
    }
}



