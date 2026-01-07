//
//  AccountModel.swift
//  LinkSkill
//
//  Created by Rohit SIngh Dhakad on 02/11/25.
//

import Foundation


class BannerModel: NSObject {
    
    var id: String?
    var image: String?
    var title: String?
    
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["id"] as? Int {
            id = "\(value)"
        } else if let value = dictionary["id"] as? String {
            id = value
        } else {
            id = ""
        }
        
        if let value = dictionary["image"] as? String {
            image = value
        }
    
        if let value = dictionary["title"] as? String {
            title = value
        }
    
    }
}
