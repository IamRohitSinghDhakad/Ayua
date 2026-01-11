//
//  ProfessionalTableViewCell.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 11/01/26.
//

import UIKit

class ProfessionalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblBidPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnOnAward: UIButton!
    @IBOutlet weak var btnOnChat: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
