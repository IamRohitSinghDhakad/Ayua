//
//  SideMenuTableViewCell.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
           super.awakeFromNib()
           selectionStyle = .none
       }

       func configure(
           with item: MenuItem,
           isSelected: Bool
       ) {
           lblTitle.text = item.title

           let imageName = isSelected ? item.iconActive : item.iconInactive
           imgVw.image = UIImage(named: imageName ?? "")

           // Optional styling
           lblTitle.textColor = isSelected ? .white : .black
           contentView.backgroundColor = isSelected ? UIColor(hex: "#1D1529") : .white
       }
   }
