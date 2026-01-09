//
//  PendingTableViewCell.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 09/01/26.
//

import UIKit
import SDWebImage

class PendingTableViewCell: UITableViewCell {

    @IBOutlet weak var vwServices: UIView!
    @IBOutlet weak var vwUserDetails: UIView!
    @IBOutlet weak var vwButtons: UIView!
    @IBOutlet weak var lblServiceNames: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblAwatrded: UILabel!
    @IBOutlet weak var lblrating: UILabel!
    
    
    @IBOutlet weak var vwImageView: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgOne: UIImageView!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var imgThree: UIImageView!
    @IBOutlet weak var imgFour: UIImageView!
    
    @IBOutlet weak var btnCallToProfessional: UIButton!
    @IBOutlet weak var btnChatWithProfessional: UIButton!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            resetImages()
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            resetImages()
        }

        private func resetImages() {
            [imgOne, imgTwo, imgThree, imgFour].forEach {
                $0?.isHidden = true
                $0?.image = nil
            }
            vwImageView.isHidden = true
        }

        func configureImages(_ imageUrls: [String]) {

            let imageViews = [imgOne, imgTwo, imgThree, imgFour]

            guard imageUrls.count > 0 else {
                vwImageView.isHidden = true
                return
            }

            vwImageView.isHidden = false

            for (index, url) in imageUrls.enumerated() {
                guard index < imageViews.count else { break }

                let imageView = imageViews[index]
                imageView?.isHidden = false

                if let imgUrl = URL(string: url), !url.isEmpty {
                    imageView?.sd_setImage(
                        with: imgUrl,
                        placeholderImage: UIImage(named: "logo"),
                        options: [.retryFailed, .continueInBackground]
                    )
                }
            }
        }
    }
