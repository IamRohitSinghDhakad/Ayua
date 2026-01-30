//
//  UserServiceDetailsViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 27/01/26.
//

import UIKit
import SDWebImage

class UserServiceDetailsViewController: UIViewController {
    
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserRating: UILabel!
    @IBOutlet weak var lblUserAddress: UILabel!
    @IBOutlet weak var lblUserDistancew: UILabel!
    
    @IBOutlet weak var imgVwServiceStatus: UIImageView!
    @IBOutlet weak var lblWeekDay: UILabel!
    @IBOutlet weak var lblWeekDate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var vwButtons: UIView!
    @IBOutlet weak var vwPayOnService: UIView!
    @IBOutlet weak var lblAmPM: UILabel!
    @IBOutlet weak var vwCancelService: UIView!
    @IBOutlet weak var vwDateTime: UIView!
    @IBOutlet weak var vwServiceSchedule: UIView!
    @IBOutlet weak var btnPayForService: UIButton!
    @IBOutlet weak var btnOnMyWay: UIButton!
    @IBOutlet weak var vwOnMyWay: UIView!
    
    var objJob: JobsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    func setData() {
        
        self.vwDateTime.isHidden = true
        self.vwCancelService.isHidden = true
        self.lblAmount.isHidden = true
        self.vwOnMyWay.isHidden = true
        
        if let job = self.objJob {
            
            self.imgVwUser.sd_setImage(
                with: URL(string: job.userProfile),
                placeholderImage: UIImage(named: "logo")
            )
            self.lblUserName.text = job.userName
            self.lblUserAddress.text = job.address
            self.lblUserRating.text = job.userRating
            self.lblPrice.text = job.bidAmount
            
            if let components = job.bidDate.dateComponents() {
                self.lblWeekDay.text = components.dayName
                self.lblWeekDate.text = components.day
                self.lblMonth.text = components.month
                self.lblYear.text = components.year
            }
            
            let result1 = job.bidTime.splitTime()
            self.lblTime.text = result1.time
            self.lblAmPM.text = result1.period
            
            if job.status == "Completed" {
                self.imgVwServiceStatus.image = UIImage(resource: .step4)
            }else if job.status == "Accepted" {
                self.vwOnMyWay.isHidden = false
                self.vwCancelService.isHidden = false
            }
            
            self.btnPayForService.setTitle("Payment Status \(job.bidStatus)", for: .normal)
            self.btnPayForService.backgroundColor = UIColor.lightGray
            self.btnPayForService.setTitleColor(UIColor.darkGray, for: .normal)
        }
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnImOnMyWay(_ sender: Any) {
        
    }
    
    @IBAction func btnOnCallToProfessional(_ sender: Any) {
        let phoneNumber = objJob?.userMobile
        if let url = URL(string: "tel://\(phoneNumber ?? "")"),
           UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func btnOnChatToProfessional(_ sender: Any) {
        
    }
    
    @IBAction func btnPayForService(_ sender: Any) {
        
    }
    
    @IBAction func btnCancelService(_ sender: Any) {
        
    }
}


extension UserServiceDetailsViewController{
    
    
    func call_WebService_GetJobs(strStatus: String) {

        if !objWebServiceManager.isNetworkAvailable() {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(
                message: "No Internet Connection",
                title: "Alert",
                controller: self
            )
        }

        objWebServiceManager.showIndicator()

        let dictParam =
            [
                "provider_id": self.objJob?.providerId ?? "",
                "job_id": self.objJob?.jobId ?? "",
                "lang": objAppShareData.currentLanguage,
                "status": strStatus,
            ] as [String: Any]

        print(dictParam)
        

        objWebServiceManager.requestPost(
            strURL: WsUrl.url_update_job_status,
            queryParams: [:],
            params: dictParam,
            strCustomValidation: "",
            showIndicator: false
        ) { (response) in
            objWebServiceManager.hideIndicator()

            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [[String: Any]] {
                    print(response)
//                    self.arrJobs.removeAll()
//                    for data in resultArray {
//                        let obj = JobsModel(from: data)
//                        self.arrJobs.append(obj)
//                    }
//                    
//
//                    if self.arrJobs.count == 0 {
//                        self.tblVw.displayBackgroundText(
//                            text: "No Jobs Available",
//                            fontStyle: "ABeeZee-Regular",
//                            fontSize: 22
//                        )
//                    } else {
//                        self.tblVw.displayBackgroundText(text: "")
//                    }
//                    self.refreshControl.endRefreshing()
//                    self.arrJobs.reverse()
//                    self.tblVw.reloadData()
                }
            } else {
              // self.arrJobs.removeAll()
              //  self.refreshControl.endRefreshing()
//                if self.arrJobs.count == 0 {
//                    self.tblVw.displayBackgroundText(
//                        text: "No Jobs Available",
//                        fontStyle: "ABeeZee-Regular",
//                        fontSize: 22
//                    )
//                    self.tblVw.reloadData()
//                } else {
//                    self.tblVw.displayBackgroundText(text: "")
//                }
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
          //  self.refreshControl.endRefreshing()
            print("Error \(error)")
        }
    }
    
    
    /*
     @POST("update_job_status")
     Call<ResponseBody> update_job_status(@Query("job_id") String job_id,
                                          @Query("provider_id") String provider_id,
                                          @Query("status") String status,
                                          @Query("lang") String language);

     */
    
}
