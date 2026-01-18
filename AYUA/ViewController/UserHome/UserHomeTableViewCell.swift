//
//  UserHomeTableViewCell.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 18/01/26.
//

import UIKit

class UserHomeTableViewCell: UITableViewCell {
    @IBOutlet weak var userVw: UIView!
    @IBOutlet weak var bidVw: UIView!
    @IBOutlet weak var sendOffervw: UIView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAverageRating: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var btnSendOffer: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
