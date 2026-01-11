//
//  AcceptedTableViewCell.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 09/01/26.
//

import UIKit
import SDWebImage

class AcceptedTableViewCell: UITableViewCell {
    @IBOutlet weak var vwServices: UIView!
    @IBOutlet weak var vwUsers: UIView!
    @IBOutlet weak var vwDetail: UIView!
    @IBOutlet weak var vwImages: UIView!
    @IBOutlet weak var vwButtons: UIView!
    
    @IBOutlet weak var lblServiceNames: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblAwatrded: UILabel!
    @IBOutlet weak var lblrating: UILabel!
    
    @IBOutlet weak var lbldetail: UILabel!
    
    @IBOutlet weak var imgOne: UIImageView!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var imgThree: UIImageView!
    @IBOutlet weak var imgFour: UIImageView!
    
    @IBOutlet weak var btnCallToProfessional: UIButton!
    @IBOutlet weak var btnChatWithProfessional: UIButton!

    override func awakeFromNib() {
            super.awakeFromNib()
            resetImages()
        self.vwServices.isHidden = true
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
            vwImages.isHidden = true
        }

        func configureImages(_ imageUrls: [String]) {

            let imageViews = [imgOne, imgTwo, imgThree, imgFour]

            guard imageUrls.count > 0 else {
                vwImages.isHidden = true
                return
            }

            vwImages.isHidden = false

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
