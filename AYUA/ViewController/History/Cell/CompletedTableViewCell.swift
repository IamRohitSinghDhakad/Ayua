//
//  CompletedTableViewCell.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 09/01/26.
//

import UIKit

class CompletedTableViewCell: UITableViewCell {

    @IBOutlet weak var vwServices: UIView!
    @IBOutlet weak var vwUser: UIView!
    @IBOutlet weak var vwLocation: UIView!
    
    @IBOutlet weak var lblAddressB: UILabel!
    @IBOutlet weak var lblAddressA: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblAwatrded: UILabel!
    @IBOutlet weak var lblrating: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
