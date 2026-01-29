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
    
    var objJob: JobsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }

    func setData() {

        self.vwDateTime.isHidden = true
        self.vwCancelService.isHidden = true
        self.lblAmount.isHidden = true
        
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
            }
            
            if job.status == "Completed" || job.status == "Awarded" {
                if job.bidStatus == "Pending"{
                    self.vwPayOnService.isHidden = false
                    self.vwCancelService.isHidden = true
                }else{
                    vwButtons.isHidden = true
                }
            }else{
                self.vwPayOnService.isHidden = false
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

    @IBAction func btnOnCallToProfessional(_ sender: Any) {
        let phoneNumber = objJob?.providerMobile

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

