//
//  HomeCollectionViewCell.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 06/01/26.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgvwCell: UIImageView!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           imgvwCell.contentMode = .scaleAspectFill
           imgvwCell.clipsToBounds = true
       }
}
