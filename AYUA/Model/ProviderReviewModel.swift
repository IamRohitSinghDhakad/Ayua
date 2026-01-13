//
//  ProviderReviewModel.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 13/01/26.
//

import Foundation
import UIKit

class ProviderReviewModel: NSObject {
    
    var status: String = ""
    var userName: String = ""
    var averageRating: String = ""
    var profileImage: String = ""
    var message: String = ""
    var reviews: [ProviderReviewItem] = []
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["status"] as? Int {
            status = "\(value)"
        } else if let value = dictionary["status"] as? String {
            status = value
        }
        
        if let value = dictionary["user_name"] as? String {
            userName = value
        }
        
        if let value = dictionary["average_rating"] as? Double {
            averageRating = "\(value)"
        } else if let value = dictionary["average_rating"] as? String {
            averageRating = value
        }
        
        if let value = dictionary["profile"] as? String {
            profileImage = value
        }
        
        if let value = dictionary["message"] as? String {
            message = value
        }
        
        if let resultArray = dictionary["result"] as? [[String: Any]] {
            for obj in resultArray {
                let model = ProviderReviewItem(from: obj)
                reviews.append(model)
            }
        }
    }
}


class ProviderReviewItem: NSObject {
    
    var reviewId: String = ""
    var jobId: String = ""
    var fromUserId: String = ""
    var toUserId: String = ""
    var reviewerName: String = ""
    var reviewerProfile: String = ""
    var rating: String = ""
    var review: String = ""
    var entryDate: String = ""
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["id"] as? Int {
            reviewId = "\(value)"
        } else if let value = dictionary["id"] as? String {
            reviewId = value
        }
        
        if let value = dictionary["job_id"] as? Int {
            jobId = "\(value)"
        } else if let value = dictionary["job_id"] as? String {
            jobId = value
        }
        
        if let value = dictionary["from_user_id"] as? Int {
            fromUserId = "\(value)"
        } else if let value = dictionary["from_user_id"] as? String {
            fromUserId = value
        }
        
        if let value = dictionary["to_user_id"] as? Int {
            toUserId = "\(value)"
        } else if let value = dictionary["to_user_id"] as? String {
            toUserId = value
        }
        
        if let value = dictionary["reviewer_name"] as? String {
            reviewerName = value
        }
        
        if let value = dictionary["reviewer_profile"] as? String {
            reviewerProfile = value
        }
        
        if let value = dictionary["rating"] as? Double {
            rating = "\(value)"
        } else if let value = dictionary["rating"] as? String {
            rating = value
        }
        
        if let value = dictionary["review"] as? String {
            review = value
        }
        
        if let value = dictionary["entrydt"] as? String {
            entryDate = value
        }
    }
}
