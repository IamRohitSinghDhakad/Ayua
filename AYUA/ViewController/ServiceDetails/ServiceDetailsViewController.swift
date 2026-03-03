//
//  ServiceDetailsViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 25/01/26.
//

import UIKit
import SDWebImage

class ServiceDetailsViewController: UIViewController {
    
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var txtVw: UITextView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var lblSelectdate: UILabel!
    @IBOutlet weak var lblSelectTime: UILabel!
    @IBOutlet weak var lblServices: UILabel!
    
    var objJobDetails: JobsModel?
    
    var strSelectedDate: String?
    var strSelectedTime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
    }
    
    func setData() {
        self.lblUserName.text = objJobDetails?.userName
        self.lblAddress.text = objJobDetails?.address
        self.lblRating.text = objJobDetails?.userRating
        self.lblServices.text = objJobDetails?.subCategoryName
        self.txtVw.text = objJobDetails?.detail
        
        // MARK: - Set User Profile Image
        
        imgVwUser.sd_cancelCurrentImageLoad()
        imgVwUser.image = nil
        
        if let userImageString = objJobDetails?.userProfile
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !userImageString.isEmpty,
           let userImageURL = URL(string: userImageString) {
            
            imgVwUser.sd_setImage(with: userImageURL, completed: nil)
        } else {
            imgVwUser.isHidden = true   // hide if no image
        }
        
        let images = [
            objJobDetails?.image1,
            objJobDetails?.image2,
            objJobDetails?.image3,
            objJobDetails?.image4
        ]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        configureImages(images)
    }
    
    func configureImages(_ imageUrls: [String]) {
        
        let imageViews = [img1, img2, img3, img4]
        
        // Reset everything first
        imageViews.forEach {
            $0?.sd_cancelCurrentImageLoad()
            $0?.image = nil
            $0?.isHidden = true
        }
        
        for (index, urlString) in imageUrls.enumerated() {
            guard index < imageViews.count,
                  let url = URL(string: urlString),
                  let imageView = imageViews[index] else { continue }
            
            imageView.isHidden = false
            
            imageView.sd_setImage(
                with: url,
                completed: nil   // No placeholder at all
            )
        }
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnOnSelectDate(_ sender: Any) {
        showDatePicker(mode: .date, title: "Select Date") { [weak self] selectedDate in
               
               let displayFormatter = DateFormatter()
               displayFormatter.dateFormat = "dd MMM yyyy"
               self?.lblSelectdate.text = displayFormatter.string(from: selectedDate)
               
               let apiFormatter = DateFormatter()
               apiFormatter.dateFormat = "yyyy-MM-dd"
               self?.strSelectedDate = apiFormatter.string(from: selectedDate)
           }
    }
    
    @IBAction func btnOnSelectTime(_ sender: Any) {
        showDatePicker(mode: .time, title: "Select Time") { [weak self] selectedTime in
               
               let displayFormatter = DateFormatter()
               displayFormatter.dateFormat = "hh:mm a"
               self?.lblSelectTime.text = displayFormatter.string(from: selectedTime)
               
               let apiFormatter = DateFormatter()
               apiFormatter.dateFormat = "HH:mm:ss"
               self?.strSelectedTime = apiFormatter.string(from: selectedTime)
           }
    }
    
    @IBAction func btnOnSendOffer(_ sender: Any) {
        self.call_WebService_GetJobs(strJobId: self.objJobDetails?.jobId ?? "")
    }
}

extension ServiceDetailsViewController{
    private func showDatePicker(mode: UIDatePicker.Mode,
                                title: String,
                                completion: @escaping (Date) -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: "\n\n\n\n\n\n\n",
                                      preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = mode
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 45),
            datePicker.heightAnchor.constraint(equalToConstant: 216)
        ])
        
        
        let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
            completion(datePicker.date)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}


extension ServiceDetailsViewController{
    
    
    func call_WebService_GetJobs(strJobId: String) {
        
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
            "provider_id": objAppShareData.UserDetail.strUserId!,
            "lang": objAppShareData.currentLanguage,
            "job_id": strJobId,
            "bid_amount": tfAmount.text ?? "",
            "date": strSelectedDate ?? "",
            "time": strSelectedTime ?? "",
            "proposal": "Proposal",
        ] as [String: Any]

        
        print(dictParam)
        
        
        objWebServiceManager.requestPost(
            strURL: WsUrl.url_place_bid,
            queryParams: [:],
            params: dictParam,
            strCustomValidation: "",
            showIndicator: false
        ) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [String: Any] {
                    print(response)
                    
                    self.onBackPressed()
                    
                   
                }
            } else {
                
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            
            print("Error \(error)")
        }
    }
}
