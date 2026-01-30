//
//  ChatDetailTableViewCell.swift
//  LinkSkill
//
//  Created by Rohit Singh Dhakad  [C] on 14/10/25.
//

import UIKit
import SDWebImage

class ChatDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var vwMyMsg: UIView!
    @IBOutlet weak var vwOpponentMessage: UIView!
    @IBOutlet weak var vwMyImage: UIView!
    @IBOutlet weak var vwOpponentImage: UIView!
    @IBOutlet weak var vwMyDocument: UIView!
    @IBOutlet weak var vwOpponentDocumnet: UIView!
    @IBOutlet weak var lblMyMsgTxt: UILabel!
    @IBOutlet weak var lblMyMsgTime: UILabel!
    @IBOutlet weak var lblOpponentTxtMsg: UILabel!
    @IBOutlet weak var lblOpponentTimeTxt: UILabel!
    @IBOutlet weak var imgVwMy: UIImageView!
    @IBOutlet weak var lblTimeImageMySide: UILabel!
    @IBOutlet weak var imgVwopponent: UIImageView!
    @IBOutlet weak var lblImgTimeOpponent: UILabel!
    @IBOutlet weak var btnMyDoc: UIButton!
    @IBOutlet weak var btnOpponentDoc: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(
        with model: ChatDetailModel,
        isOpponent: Bool,
        index: Int,
        target: Any
    ) {
        resetViews()

        switch (model.strType, isOpponent) {
        case ("text", true):
            vwOpponentMessage.isHidden = false
            lblOpponentTxtMsg.text = model.strOpponentChatMessage
            lblOpponentTimeTxt.text = model.strOpponentChatTime

        case ("image", true):
            vwOpponentImage.isHidden = false
            lblImgTimeOpponent.text = model.strOpponentChatTime
            imgVwopponent.sd_setImage(with: URL(string: model.strImageUrl))

        case ("file", true):
            vwOpponentDocumnet.isHidden = false
            btnOpponentDoc.tag = index
            btnOpponentDoc.addTarget(target, action: #selector(ChatDetailViewController.openDocument(_:)), for: .touchUpInside)

        case ("text", false):
            vwMyMsg.isHidden = false
            lblMyMsgTxt.text = model.strOpponentChatMessage
            lblMyMsgTime.text = model.strOpponentChatTime

        case ("image", false):
            vwMyImage.isHidden = false
            lblTimeImageMySide.text = model.strOpponentChatTime
            imgVwMy.sd_setImage(with: URL(string: model.strImageUrl))

        case ("file", false):
            vwMyDocument.isHidden = false
            btnMyDoc.tag = index
            btnMyDoc.addTarget(target, action: #selector(ChatDetailViewController.openDocument(_:)), for: .touchUpInside)

        default:
            break
        }
    }

    private func resetViews() {
        [vwMyMsg, vwOpponentMessage, vwMyImage, vwOpponentImage, vwMyDocument, vwOpponentDocumnet]
            .forEach { $0?.isHidden = true }
    }

}
