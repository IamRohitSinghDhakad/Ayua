//
//  JobDetailViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 11/01/26.
//

import SDWebImage
import UIKit

class JobDetailViewController: UIViewController {

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

    var objJob: JobsModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
    }

    func setData() {
        if let job = self.objJob {

            self.imgVwUser.sd_setImage(
                with: URL(string: job.providerProfile),
                placeholderImage: UIImage(named: "logo")
            )
            self.lblUserName.text = job.providerName
            self.lblUserAddress.text = job.address
            self.lblUserRating.text = job.providerRating
            self.lblPrice.text = job.bidAmount

            if let components = job.bidDate.dateComponents() {
                self.lblWeekDay.text = components.dayName
                self.lblWeekDate.text = components.day
                self.lblMonth.text = components.month
                self.lblYear.text = components.year
            }
            
            let result1 = job.bidTime.splitTime()
            
            
            //self.lblUserDistancew.text = job.userAddress
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
