//
//  ProposalModel.swift
//  LinkSkill
//
//  Created by Rohit Singh Dhakad  [C] on 16/10/25.
//
import Foundation

class BidProposalModel: NSObject {
    
    var id: String?
    var jobId: String?
    var providerId: String?
    
    var price: Double?
    var deliveryTime: String?
    var proposal: String?
    var status: String?
    
    var date: String?
    var time: String?
    var entryDate: String?
    
    var providerName: String?
    var providerEmail: String?
    var providerMobile: String?
    var providerProfile: String?
    
    var categoryId: String?
    var subCategoryId: String?
    var category: String?
    var subCategory: String?
    
    var rating: String?
    var reviewCount: String?
    var completedJobs: String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        // MARK: - ID
        if let value = dictionary["id"] {
            id = "\(value)"
        } else {
            id = ""
        }
        
        // MARK: - Job ID
        if let value = dictionary["job_id"] {
            jobId = "\(value)"
        } else {
            jobId = ""
        }
        
        // MARK: - Provider ID
        if let value = dictionary["provider_id"] {
            providerId = "\(value)"
        } else {
            providerId = ""
        }
        
        // MARK: - Bid Amount
        if let value = dictionary["bid_amount"] as? Double {
            price = value
        } else if let value = dictionary["bid_amount"] as? String,
                  let doubleVal = Double(value) {
            price = doubleVal
        } else {
            price = 0.0
        }
        
        // MARK: - Delivery Time
        if let value = dictionary["delivery_time"] {
            deliveryTime = "\(value)"
        } else {
            deliveryTime = ""
        }
        
        // MARK: - Proposal
        proposal = dictionary["proposal"] as? String ?? ""
        
        // MARK: - Status
        status = dictionary["status"] as? String ?? ""
        
        // MARK: - Date & Time
        date = dictionary["date"] as? String ?? ""
        time = dictionary["time"] as? String ?? ""
        entryDate = dictionary["entrydt"] as? String ?? ""
        
        // MARK: - Provider Info
        providerName = dictionary["provider_name"] as? String ?? ""
        providerEmail = dictionary["provider_email"] as? String ?? ""
        providerMobile = dictionary["provider_mobile"] as? String ?? ""
        providerProfile = dictionary["provider_profile"] as? String ?? ""
        
        // MARK: - Category
        categoryId = dictionary["category_id"] as? String ?? ""
        subCategoryId = dictionary["sub_category_id"] as? String ?? ""
        category = dictionary["category"] as? String ?? ""
        subCategory = dictionary["sub_category"] as? String ?? ""
        
        // MARK: - Rating & Reviews
        if let value = dictionary["rating"] {
            rating = "\(value)"
        } else {
            rating = ""
        }
        
        if let value = dictionary["review_count"] {
            reviewCount = "\(value)"
        } else {
            reviewCount = ""
        }
        
        // MARK: - Completed Jobs
        if let value = dictionary["completed_jobs"] {
            completedJobs = "\(value)"
        } else {
            completedJobs = ""
        }
    }
}
