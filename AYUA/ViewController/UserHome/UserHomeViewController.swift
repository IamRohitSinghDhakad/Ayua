//
//  UserHomeViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 18/01/26.
//

import UIKit
import CoreLocation
import SDWebImage
import SwiftUI

class UserHomeViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var tblVw: UITableView!
    private var locationManager: CLLocationManager?
    var currentLat: String = ""
    var currentLong: String = ""
    var arrJobs = [JobsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupTableView()
        call_WebService_GetJobs()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        
        // Start updating location if authorized
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    
    private func setupTableView() {
        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.separatorStyle = .none
        
        let nib = UINib(nibName: "UserHomeTableViewCell", bundle: nil)
        tblVw.register(nib, forCellReuseIdentifier: "UserHomeTableViewCell")
    }
    
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        SideMenuManager.shared.showMenu(from: self)
    }
    
    @IBAction func btnOpenNotificationScreen(_ sender: Any) {
        
        let vm = NotificationsViewModel()
        let notificationView = NotificationsView()

        let hostingVC = UIHostingController(rootView: notificationView)
        UIApplication.shared.topViewController()?
            .navigationController?
            .pushViewController(hostingVC, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Stop updating to save battery
        manager.stopUpdatingLocation()
        
        currentLat = "\(location.coordinate.latitude)"
        currentLong = "\(location.coordinate.longitude)"
        
        // Reverse geocode to get address
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
//            guard let self = self else { return }
//            
//            if let placemark = placemarks?.first {
//                var addressParts: [String] = []
//                
//                if let subThoroughfare = placemark.subThoroughfare {
//                    addressParts.append(subThoroughfare)
//                }
//                if let thoroughfare = placemark.thoroughfare {
//                    addressParts.append(thoroughfare)
//                }
//                if let locality = placemark.locality {
//                    addressParts.append(locality)
//                }
//                if let administrativeArea = placemark.administrativeArea {
//                    addressParts.append(administrativeArea)
//                }
//                if let postalCode = placemark.postalCode {
//                    addressParts.append(postalCode)
//                }
//                
//                let fullAddress = addressParts.joined(separator: ", ")
//                self.currentAddress = fullAddress
//                self.lblAddress.text = fullAddress
//            }
//        }
    }
}

extension UserHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrJobs.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let job = arrJobs[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "UserHomeTableViewCell",
            for: indexPath
        ) as! UserHomeTableViewCell

        if job.status == "Pending" {
            cell.userVw.isHidden = false
            cell.bidVw.isHidden = true
            cell.sendOffervw.isHidden = false
        }else{
            cell.bidVw.isHidden = false
            cell.sendOffervw.isHidden = true
        }
        
        if job.isBidded == "1"{
            cell.bidVw.isHidden = false
            cell.sendOffervw.isHidden = true
        }else{
            cell.bidVw.isHidden = true
            cell.sendOffervw.isHidden = false
        }
        
        cell.lblDistance.text = String.distanceInKM(
            fromLat: currentLat,
            fromLng: currentLong,
            toLat: job.lat,
            toLng: job.lng
        )
        
        cell.lblUserName.text = job.userName
        cell.lblAverageRating.text = job.userRating
        cell.imgVwUser.sd_setImage(
            with: URL(string: job.userProfile),
            placeholderImage: UIImage(named: "logo")
        )
        cell.lblAddress.text = job.address
        cell.lblDetails.text = job.detail
        cell.lblSubcategory.text = job.subCategoryName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(
            withIdentifier: "ServiceDetailsViewController"
        ) as! ServiceDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserHomeViewController{
    
    func call_WebService_GetJobs() {

        if !objWebServiceManager.isNetworkAvailable() {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(
                message: "No Internet Connection",
                title: "Alert",
                controller: self
            )
        }

        objWebServiceManager.showIndicator()
        

        let dictParam =
            [
                "provider_id": objAppShareData.UserDetail.strUserId!,
                "lang": objAppShareData.currentLanguage,
                "status": "Pending",
                "lat": self.currentLat,
                "lng": self.currentLong
                
            ] as [String: Any]

        print(dictParam)

        objWebServiceManager.requestPost(
            strURL: WsUrl.url_getProviderJobs,
            queryParams: [:],
            params: dictParam,
            strCustomValidation: "",
            showIndicator: false
        ) { (response) in
            objWebServiceManager.hideIndicator()

            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [[String: Any]] {
                    print(response)
                    self.arrJobs.removeAll()
                    for data in resultArray {
                        let obj = JobsModel(from: data)
                        self.arrJobs.append(obj)
                    }
                    

                    if self.arrJobs.count == 0 {
                        self.tblVw.displayBackgroundText(
                            text: "No Jobs Available",
                            fontStyle: "ABeeZee-Regular",
                            fontSize: 22
                        )
                    } else {
                        self.tblVw.displayBackgroundText(text: "")
                    }
                   // self.refreshControl.endRefreshing()
                    self.arrJobs.reverse()
                    self.tblVw.reloadData()
                }
            } else {
                self.arrJobs.removeAll()
               // self.refreshControl.endRefreshing()
                if self.arrJobs.count == 0 {
                    self.tblVw.displayBackgroundText(
                        text: "No Jobs Available",
                        fontStyle: "ABeeZee-Regular",
                        fontSize: 22
                    )
                    self.tblVw.reloadData()
                } else {
                    self.tblVw.displayBackgroundText(text: "")
                }
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
           // self.refreshControl.endRefreshing()
            print("Error \(error)")
        }
    }
    
}
