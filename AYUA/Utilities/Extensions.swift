//
//  Extensions.swift
//  FitMate
//
//  Created by Rohit SIngh Dhakad on 18/06/23.
//

import Foundation
import UIKit
import AVKit

extension UserDefaults {
    enum Keys {
        
        static let strVenderId = "udid"
        
        static let strAccessToken = "access_token"
        
        static let AuthToken = "AuthToken"
        
        static let userID = "userID"
        
        static let userType = "userType"
        
    }
}

extension UIViewController : UITextFieldDelegate  {
    
    
    func SetBackGroundImageAtViewAndImageName(ImageName: NSString, view: UIView)
    {
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: ImageName as String)?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    
    
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>> Hide Keyboard <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>> Validate Emailid <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func isValidEmail(stringValue: String) ->Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: stringValue)
    }
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>> Dismiss ViewController <<<<<<<<<<<<<<<<<<<<<<<<<<
    func onBackPressed() {
        
        if let navigation = self.navigationController
            
        {
            navigation.popViewController(animated: true)
        }
        
        else
        
        {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>> Present ViewController <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func presentVC(viewConterlerId : String)     {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewConterlerId)
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>> Push ViewController <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func pushVc(viewConterlerId:String){
        
        let vc = storyboard?.instantiateViewController(withIdentifier: viewConterlerId)
        navigationController?.pushViewController(vc!,
                                                 animated: true)
        
    }
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>> Show Alert With Single Button <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func showAlertWithSingleButton(Title: String, Message: String)  {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
            //Ok action
            // self.present(alert, animated: true, completion: nil)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>> Show Alert With Multi Button <<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func showAlertWithMultiButton(Title: String, Message: String)  {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            self.present(alert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
            //ok action
            self.present(alert, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //Mark:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Check string Null <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    func isStringNullValue(strValues: String) -> Bool {
        var isNull:Bool = true
        
        if strValues == nil || strValues == "(null)" || strValues == "<null>"  || strValues == "" {
            isNull = true
        }
        else
        {
            isNull = false
        }
        // strValues.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines
        return isNull
    }
    
    func isValid(_ object:AnyObject!) -> Bool
    {
        if let _:AnyObject = object
        {
            return true
        }
        
        return false
    }
}


extension UIViewController {
    func shareTextImageAndURL(text: String, image: UIImage, url: URL, sourceView: UIView) {
        let textItem = text as NSString
        let imageItem = image as NSObject
        let urlItem = url as NSObject
        
        let activityViewController = UIActivityViewController(activityItems: [textItem, imageItem, urlItem], applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .saveToCameraRoll,
            .print,
            .addToReadingList
        ]
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Convert Way64 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
extension String {
    
    func localized() -> String{
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> show Activity Indicator <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
/*
 extension UIActivityIndicatorView {
 convenience init(activityIndicatorStyle: UIActivityIndicatorView.Style, color: UIColor, placeInTheCenterOf parentView: UIView) {
 self(style: activityIndicatorStyle)
 center = parentView.center
 self.color = color
 parentView.addSubview(self)
 }
 }
 */

extension UITextField {
    func setIconLeftSide(_ image: UIImage) {
        let iconView = UIImageView(frame:
                                    CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UILabel {//Write this extension after close brackets of your class
    func lblFunction() {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping//If you want word wraping
        //OR
        //  lineBreakMode = .byCharWrapping//If you want character wraping
    }
}

extension UIView{
    
    func roundedCorners(corners : UIRectCorner, radius : CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func viewShadowHeader() {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1.0
        self.layer.shadowColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    }
    
    func viewShadowHeaderWithCorner(corner:CGFloat) {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1.0
        self.layer.cornerRadius = corner
        self.layer.shadowColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    }
}


extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIViewController {
    
    var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    var authStoryboard: UIStoryboard {
        return UIStoryboard(name: "Auth", bundle: nil)
    }
    
}


//Animk,ations
extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
}

extension UIImageView {
    
    func getThumbnailImage(with url: URL?, placeholderImage: UIImage) {
        self.image = placeholderImage
        if let videoURL = url {
            let asset: AVAsset = AVAsset(url: videoURL)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            do {
                let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
                let imageGenerated = UIImage(cgImage: thumbnailImage)
                self.image = imageGenerated
            } catch let error {
                print(error)
                self.image = placeholderImage
            }
        }
    }
    
    func getThumbnailImageFromVideoUrl(videoURL: URL?, placeholderImage: UIImage) {
        self.image = placeholderImage
        if let url = videoURL {
            DispatchQueue.global().async { //1
                let asset = AVAsset(url: url) //2
                let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
                avAssetImageGenerator.appliesPreferredTrackTransform = true //4
                let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
                do {
                    let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                    let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                    DispatchQueue.main.async { //8
                        self.image = thumbNailImage
                    }
                } catch {
                    print(error.localizedDescription) //10
                    DispatchQueue.main.async {
                        self.image = placeholderImage
                    }
                }
            }
        }
    }
}

extension UIViewController {
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
}

extension Date {
    /// to get time since 1970 till current time in milliseconds
    func toMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension String {
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}

extension String {
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
}


extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hex = hex.replacingOccurrences(of: "#", with: "")
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            red: CGFloat((int >> 16) & 0xff) / 255,
            green: CGFloat((int >> 8) & 0xff) / 255,
            blue: CGFloat(int & 0xff) / 255,
            alpha: 1
        )
    }
}

extension UIView {

    func applySoftShadow(
        color: UIColor = .black,
        opacity: Float = 0.15,
        offset: CGSize = CGSize(width: 0, height: 3),
        radius: CGFloat = 6,
        cornerRadius: CGFloat = 12
    ) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.cornerRadius = cornerRadius

        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
    }
}



extension UIView {
    
    func setCornerRadiusIndiviualCorners(radius: CGFloat, corners: UIRectCorner) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    /**
     Shows the view with a top-to-down animation
     */
    func showAnimated() {
        // Calculate the height of the safe area
        let safeAreaHeight = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        // Set the new frame for the view to its original position, with the y origin adjusted for the safe area
        let newFrame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: safeAreaHeight), size: self.frame.size)
        // Make sure the view is not hidden
        self.isHidden = false
        // Animate the frame change over 0.3 seconds
        UIView.animate(withDuration: 0.3) {
            self.frame = newFrame
        }
    }
    
    /**
     Hides the view with a down-to-top animation
     */
    func hideAnimated() {
        // Set the new frame for the view to be offscreen
        let newFrame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: -self.frame.size.height), size: self.frame.size)
        // Animate the frame change over 0.3 seconds
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = newFrame
        }) { _ in
            // Set the view to hidden once the animation is complete
            self.isHidden = true
        }
    }
}

extension String {
    func formattedTimeRange(toTime toTimeStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let startDate = dateFormatter.date(from: self),
           let endDate = dateFormatter.date(from: toTimeStr) {
            
            dateFormatter.dateFormat = "HH:mm"
            
            let startTime = dateFormatter.string(from: startDate)
            let endTime = dateFormatter.string(from: endDate)
            
            return "\(startTime)-\(endTime) h"
        }
        
        return nil
    }
    
    func extractTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: self) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return timeFormatter.string(from: date)
        } else {
            return nil // Invalid date string
        }
    }
}

extension String {
    func formattedDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        }
        
        return nil
    }
}

extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}


extension UIViewController {

    func presentShareSheet(description: String, appLink: String) {
        // Combine the description and app link to share
        let textToShare = "\(description)\n\nDownload the app here: \(appLink)"
        
        // Create an array of items to share
        let itemsToShare = [textToShare]
        
        // Create the share sheet (UIActivityViewController)
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        // Exclude some activities if you don't want them
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact]
        
        // Present the share sheet
        self.present(activityViewController, animated: true, completion: nil)
    }
}


extension String {
    

    /// Calculates distance in KM between two coordinates (all inputs as String)
    static func distanceInKM(fromLat currentLat: String,fromLng currentLng: String,toLat otherLat: String,toLng otherLng: String) -> String {

        print(currentLat, currentLng, otherLat, otherLng)
        guard
            let lat1 = Double(currentLat),
            let lon1 = Double(currentLng),
            let lat2 = Double(otherLat),
            let lon2 = Double(otherLng)
        else {
            return "0 km"
        }

        let earthRadius = 6371.0 // KM

        let dLat = (lat2 - lat1) * .pi / 180
        let dLon = (lon2 - lon1) * .pi / 180

        let a =
            sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1 * .pi / 180) *
            cos(lat2 * .pi / 180) *
            sin(dLon / 2) * sin(dLon / 2)

        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distance = earthRadius * c

        return String(format: "%.2f km", distance)
    }

    
    func dateComponents() -> (dayName: String,
                              day: String,
                              month: String,
                              year: String)? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        let calendar = Calendar.current
        
        // Day name 
        let dayNameFormatter = DateFormatter()
        dayNameFormatter.dateFormat = "EEEE"
        let dayName = dayNameFormatter.string(from: date)
        
        // Day
        let day = String(calendar.component(.day, from: date))
        
        // Month
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        let month = monthFormatter.string(from: date)
        
        // Year
        let year = String(calendar.component(.year, from: date))
        
        return (dayName, day, month, year)
    }
    
    func splitTime() -> (time: String, period: String?) {
           
           let components = self.split(separator: " ")
           
           if components.count == 2 {
               // Format: "5:40 AM"
               return (time: String(components[0]), period: String(components[1]))
           } else {
               // Format: "09:00:000" or any other format
               return (time: self, period: nil)
           }
       }
}
