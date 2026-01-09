//
//  HomeModel.swift
//  Culturally Yours App
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 26/04/25.
//

import UIKit
import Foundation

class JobsModel: NSObject {

    // MARK: - Job Core
    var jobId: String = ""
    var status: String = ""
    var detail: String = ""
    var entryDate: String = ""
    var address: String = ""
    var categoryId: String = ""
    var categoryName: String = ""
    var categoryImage: String = ""
    var subCategoryId: String = ""
    var subCategoryName: String = ""
    var virtualAmount: String = ""
    var isReviewed: String = ""

    // MARK: - Location
    var lat: String = ""
    var lng: String = ""
    var dropAddress: String = ""
    var dropLat: String = ""
    var dropLng: String = ""

    // MARK: - Images
    var image1: String = ""
    var image2: String = ""
    var image3: String = ""
    var image4: String = ""

    // MARK: - Bid Details
    var bidAmount: String = ""
    var bidDate: String = ""
    var bidTime: String = ""
    var bidStatus: String = ""

    // MARK: - User
    var userId: String = ""
    var userName: String = ""
    var userMobile: String = ""
    var userEmail: String = ""
    var userAddress: String = ""
    var userRating: String = ""
    var userProfile: String = ""

    // MARK: - Provider
    var providerId: String = ""
    var providerName: String = ""
    var providerMobile: String = ""
    var providerEmail: String = ""
    var providerAddress: String = ""
    var providerRating: String = ""
    var providerProfile: String = ""

    // MARK: - Local UI State
    var isSelected: Bool = false

    // MARK: - Init
    init(from dict: [String: Any]) {
        super.init()

        jobId          = dict.string("job_id")
        status         = dict.string("status")
        detail         = dict.string("detail")
        entryDate      = dict.string("entrydt")
        address        = dict.string("address")
        categoryId     = dict.string("category_id")
        categoryName   = dict.string("category")
        categoryImage  = dict.string("category_image")
        subCategoryId  = dict.string("sub_category_id")
        subCategoryName = dict.string("sub_category")
        virtualAmount  = dict.string("virtual_amount")
        isReviewed     = dict.string("isReviewed")

        lat           = dict.string("lat")
        lng           = dict.string("lng")
        dropAddress   = dict.string("drop_addres")
        dropLat       = dict.string("drop_lat")
        dropLng       = dict.string("drop_lng")

        image1 = dict.string("image1")
        image2 = dict.string("image2")
        image3 = dict.string("image3")
        image4 = dict.string("image4")

        // Bid Details
        if let bid = dict["bidDetails"] as? [String: Any] {
            bidAmount = bid.string("bid_amount")
            bidDate   = bid.string("date")
            bidTime   = bid.string("time")
            bidStatus = bid.string("status")
        }

        // User Details
        userId = dict.string("user_id")
        if let user = dict["userdetail"] as? [String: Any] {
            userName    = user.string("name")
            userMobile  = user.string("mobile")
            userEmail   = user.string("email")
            userAddress = user.string("address")
            userRating  = user.string("avg_rating")
            userProfile = user.string("profile")
        }

        // Provider Details
        providerId = dict.string("provider_id")
        if let provider = dict["providerdetail"] as? [String: Any] {
            providerName    = provider.string("name")
            providerMobile  = provider.string("mobile")
            providerEmail   = provider.string("email")
            providerAddress = provider.string("address")
            providerRating  = provider.string("avg_rating")
            providerProfile = provider.string("profile")
        }
    }
}



extension Dictionary where Key == String {

    func string(_ key: String) -> String {
        guard let value = self[key] else { return "" }

        if let str = value as? String {
            return str
        } else if let intVal = value as? Int {
            return String(intVal)
        } else if let doubleVal = value as? Double {
            return String(doubleVal)
        } else {
            return ""
        }
    }
}
