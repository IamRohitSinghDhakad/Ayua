//
//  CompleteTableViewCell.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 27/01/26.
//

import UIKit

class CompleteTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var vwLocation: UIView!
    @IBOutlet weak var lblAddressA: UILabel!
    @IBOutlet weak var lblAddressB: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAMPM: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
