//
//  UserModel.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 25/04/21.
//

import UIKit

//class UserModel: NSObject {
//    
//    var straAuthToken : String = ""
//    var aadhar: String?
//    var address: String?
//    var approved: String?
//    var dob: String?
//    var email: String?
//    var emailVerified: String?
//    var mobile: String?
//    var mobileVerified: String?
//    var name: String?
//    var website: String?
//    var nationality: String?
//    var password: String?
//    var registerId: String?
//    var post: String?
//    var socialType: String?
//    var noncriminal_certificate_image: String?
//    var passport_image: String?
//    var status: String?
//    var is_plan_active: String?
//    var type: String?
//    var strUserId: String?
//    var userImage: String?
//    var firstName : String?
//    var lastName : String?
//    var age : String?
//    var gender : String?
//    var availability : String?
//    var price_per_hour : String?
//    var services: String?
//    var rating:Double?
//    var lang : String?
//    var category_id : String?
//    var strHourly_rate : String?
//    var strBio : String?
//    var strDuration : String?
//    var strCertificate : String?
//    var strState : String?
//    var strCountry : String?
//    var strCity : String?
//    var strRate : String?
//    var strZipCode : String?
//    
//
//    
//    
//    init(from dictionary: [String: Any]) {
//        super.init()
//       
//        if let value = dictionary["city"] as? String {
//            strCity = value
//        }
//        
//        if let value = dictionary["zip_code"] as? String {
//            strZipCode = value
//        }else if let value = dictionary["zip_code"] as? Int {
//            strZipCode = "\(value)"
//        }
//       
//        if let value = dictionary["state"] as? String {
//            strState = value
//        }
//        
//        if let value = dictionary["country"] as? String {
//            strCountry = value
//        }
//        
//        if let auth_token = dictionary["device_id"] as? String{
//            self.straAuthToken = auth_token
//            UserDefaults.standard.setValue(auth_token, forKey: objAppShareData.UserDetail.straAuthToken)
//        }
//        
//        if let value = dictionary["user_id"] as? String {
//            strUserId = value
//            UserDefaults.standard.setValue(strUserId, forKey: objAppShareData.UserDetail.strUserId ?? "")
//        }else if let value = dictionary["user_id"] as? Int {
//            strUserId = "\(value)"
//            UserDefaults.standard.setValue(strUserId, forKey: objAppShareData.UserDetail.strUserId ?? "")
//        }
//        
//        if let value = dictionary["service_rate"] as? String {
//            strRate = value
//        }else if let value = dictionary["service_rate"] as? Int {
//            strRate = "\(value)"
//        }
//        
//        
//        
//        if let value = dictionary["category_id"] as? String {
//            category_id = value
//        }else if let value = dictionary["category_id"] as? Int {
//            category_id = "\(value)"
//        }
//        
//        if let services = dictionary["services"] as? String {
//            self.services = services
//        }
//        
//        if let value = dictionary["age"] as? String {
//            self.age = value
//        }
//        
//        if let myRating = dictionary["language"] as? String {
//            self.lang = myRating
//            print(self.lang ?? "")
//        }
//        
//        if let myRating = dictionary["certification"] as? String {
//            self.strCertificate = myRating
//        }
//        
//        if let duration = dictionary["duration"] as? String {
//            self.strDuration = duration
//        }
//        
//        
//        
//        if let value = dictionary["rating"] as? Double {
//            self.rating = value
//        }else if let value = dictionary["rating"] as? String {
//            self.rating = Double(value)
//        }else if let value = dictionary["rating"] as? Int {
//            self.rating = Double(value)
//        }else if let value = dictionary["rating"] as? Float {
//            self.rating = Double(value)
//        }
//        
//        
//        if let value = dictionary["availability"] as? String {
//            self.availability = value
//        }
//        
//        if let value = dictionary["price_per_hour"] as? String {
//            self.price_per_hour = value
//        }
//        
//        
//        
//        if let value = dictionary["gender"] as? String {
//            self.gender = value
//        }
//        
//        if let value = dictionary["address"] as? String {
//            address = value
//        }
//        if let value = dictionary["approved"] as? String {
//            approved = value
//        }
//        
//        if let value = dictionary["dob"] as? String {
//            dob = value
//        }
//        if let value = dictionary["email"] as? String {
//            email = value
//        }
//        if let value = dictionary["email_verified"] as? String {
//            emailVerified = value
//        }
//        if let value = dictionary["mobile"] as? String {
//            mobile = value
//        }
//        if let value = dictionary["name"] as? String {
//            name = value
//        }
//        if let value = dictionary["website"] as? String {
//            website = value
//        }
//        if let value = dictionary["nationality"] as? String {
//            nationality = value
//        }
//        if let value = dictionary["password"] as? String {
//            password = value
//        }
//        if let value = dictionary["register_id"] as? String {
//            registerId = value
//        }
//        if let value = dictionary["post"] as? String {
//            post = value
//        }
//        if let value = dictionary["social_type"] as? String {
//            socialType = value
//        }
//        if let value = dictionary["noncriminal_certificate_image"] as? String {
//            noncriminal_certificate_image = value
//        }
//        if let value = dictionary["passport_image"] as? String {
//            passport_image = value
//        }
//        if let value = dictionary["status"] as? String {
//            status = value
//        }
//        if let value = dictionary["is_plan_active"] as? String {
//            is_plan_active = value
//        }else  if let value = dictionary["is_plan_active"] as? Int {
//            is_plan_active = "\(value)"
//        }
//        
//        if let value = dictionary["type"] as? String {
//            type = value
//        }
//    
//        if let value = dictionary["user_image"] as? String {
//            userImage = value
//        }
//        if let first_name = dictionary["first_name"] as? String {
//            self.firstName = first_name
//        }
//        
//        if let last_name = dictionary["last_name"] as? String {
//            self.lastName = last_name
//        }
//        
//        if let value = dictionary["hourly_rate"] as? String {
//            self.strHourly_rate = value
//        }else if let value = dictionary["hourly_rate"] as? Int {
//            self.strHourly_rate = String(value)
//        }
//        
//        if let value = dictionary["bio"] as? String {
//            self.strBio = value
//        }
//    }
//    
//}

//
//  UserModel.swift
//  TechnicalWorld
//
//  Created by Rohit Singh Dhakad on 25/04/21.
//

import UIKit

final class UserModel: NSObject {

    // MARK: - Core (ALL STRING)
    var strUserId: String?
    var name: String?
    var email: String?
    var mobile: String?
    var password: String?
    var gender: String?
    var dob: String?
    var address: String?
    var userImage: String?
    var type: String?
    var status: String?

    // MARK: - Category
    var category: String?
    var categoryId: String?
    var categoryImage: String?
    var subCategory: String?
    var subCategoryId: String?

    // MARK: - Plan & Coins
    var planId: String?
    var planExpireDate: String?
    var coins: String?

    // MARK: - Language & Location
    var lang: String?
    var lat: String?
    var lng: String?

    // MARK: - Timing
    var openingTime: String?
    var closingTime: String?

    // MARK: - Device & Auth (DO NOT CHANGE STORAGE)
    var straAuthToken: String = ""
    var registerId: String?
    var deviceType: String?

    // MARK: - Meta
    var bio: String?
    var entryDate: String?
    var isVerified: String?
    var otp: String?
    var otpExpiry: String?
    var socialId: String?
    var stripeCustomerId: String?
    var stripeDefaultCardId: String?
    
    //MARK: - Rating
    var rating: String?

    // MARK: - Init
    init(from dictionary: [String: Any]) {
        super.init()

        // 🔒 Centralized SAFE String conversion
        func stringValue(_ key: String) -> String? {
            let value = dictionary[key]
            if value is NSNull { return nil }
            if let str = value as? String { return str }
            if let int = value as? Int { return String(int) }
            if let double = value as? Double { return String(double) }
            if let float = value as? Float { return String(float) }
            return nil
        }

        // MARK: - UserDefaults (UNCHANGED)
        if let authToken = stringValue("device_id") {
            straAuthToken = authToken
            UserDefaults.standard.setValue(
                authToken,
                forKey: objAppShareData.UserDetail.straAuthToken
            )
        }

        if let userId = stringValue("user_id") {
            strUserId = userId
            UserDefaults.standard.setValue(
                userId,
                forKey: objAppShareData.UserDetail.strUserId ?? ""
            )
        }

        // MARK: - Core
        name = stringValue("name")
        email = stringValue("email")
        mobile = stringValue("mobile")
        password = stringValue("password")
        gender = stringValue("gender")
        dob = stringValue("dob")
        address = stringValue("address")
        userImage = stringValue("user_image")
        type = stringValue("type")
        status = stringValue("status")

        // MARK: - Category
        category = stringValue("category")
        categoryId = stringValue("category_id")
        categoryImage = stringValue("category_image")
        subCategory = stringValue("sub_category")
        subCategoryId = stringValue("sub_category_id")

        // MARK: - Plan
        planId = stringValue("plan_id")
        planExpireDate = stringValue("plan_expire_date")
        coins = stringValue("coins")

        // MARK: - Language & Location
        lang = stringValue("lang")
        lat = stringValue("lat")
        lng = stringValue("lng")

        // MARK: - Timing
        openingTime = stringValue("opening_time")
        closingTime = stringValue("closing_time")

        // MARK: - Device & Auth
        registerId = stringValue("register_id")
        deviceType = stringValue("device_type")

        // MARK: - Meta
        bio = stringValue("bio")
        entryDate = stringValue("entrydt")
        isVerified = stringValue("is_verified")
        otp = stringValue("otp")
        otpExpiry = stringValue("otp_expiry")
        socialId = stringValue("social_id")
        stripeCustomerId = stringValue("stripe_customer_id")
        stripeDefaultCardId = stringValue("stripe_default_card_id")
        
        rating = stringValue("rating")
    }
}
