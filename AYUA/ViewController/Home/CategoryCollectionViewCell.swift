//
//  CategoryCollectionViewCell.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 07/01/26.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgVw.image = nil
    }
    
    func configure(isSelected: Bool, imageUrl: String?) {
        
        // Background
        vwBackground.backgroundColor = isSelected
        ? UIColor(hex: "#1D1529")
        : .white
        
//        vwBackground.layer.cornerRadius = 12
//        vwBackground.layer.masksToBounds = true
        
        vwBackground.applySoftShadow(
                opacity: isSelected ? 0.25 : 0.15
            )
        
        // Text
        lblTitle.textColor = UIColor(hex: "#1D1529")
        
        // Image
        imgVw.sd_setImage(with: URL(string: imageUrl ?? "")) { [weak self] image, _, _, _ in
            guard let self = self else { return }
            self.imgVw.image = image?.withRenderingMode(.alwaysTemplate)
            self.imgVw.tintColor = isSelected ? .white : .black
        }
    }
}
