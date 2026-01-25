//
//  UsersHistoryViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 25/01/26.
//

import UIKit
import SDWebImage

class UsersHistoryViewController: UIViewController {

    @IBOutlet weak var vwOffers: UIView!
    @IBOutlet weak var vwInProcess: UIView!
    @IBOutlet weak var vwCompleted: UIView!
    @IBOutlet weak var tblVw: UITableView!

    var arrJobs = [JobsModel]()
    private let refreshControl = UIRefreshControl()

    enum JobStatus: String {
        case pending = "Awarded"
        case accepted = "Accepted"
        case completed = "Completed"
    }

    var currentStatus: JobStatus = .pending

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        //  setupRefreshControl()
        updateTabUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        call_WebService_GetJobs(strStatus: currentStatus.rawValue)
    }
    
    @IBAction func btnOnNotification(_ sender: Any) {
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        SideMenuManager.shared.showMenu(from: self)
    }

    @IBAction func btnOffers(_ sender: Any) {
        switchTab(.pending)
    }
    @IBAction func btnInProcess(_ sender: Any) {
        switchTab(.accepted)

    }
    @IBAction func btnCompleted(_ sender: Any) {
        switchTab(.completed)
    }

    // MARK: - Helpers

    private func switchTab(_ status: JobStatus) {
        guard currentStatus != status else { return }
        currentStatus = status
        updateTabUI()
        call_WebService_GetJobs(strStatus: status.rawValue)
    }

    private func updateTabUI() {
        vwOffers.backgroundColor =
            currentStatus == .pending ? .primary : .white
        vwInProcess.backgroundColor =
            currentStatus == .accepted ? .primary : .white
        vwCompleted.backgroundColor =
            currentStatus == .completed ? .primary : .white
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(
            self,
            action: #selector(refreshData),
            for: .valueChanged
        )
        tblVw.refreshControl = refreshControl
    }

    @objc private func refreshData() {
        call_WebService_GetJobs(strStatus: currentStatus.rawValue)
    }

    private func setupTableView() {

        tblVw.register(
            UINib(nibName: "OffersTableViewCell", bundle: nil),
            forCellReuseIdentifier: "OffersTableViewCell"
        )

        tblVw.register(
            UINib(nibName: "InProcessTableViewCell", bundle: nil),
            forCellReuseIdentifier: "InProcessTableViewCell"
        )

        tblVw.register(
            UINib(nibName: "CompletedTableViewCell", bundle: nil),
            forCellReuseIdentifier: "CompletedTableViewCell"
        )

        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.rowHeight = UITableView.automaticDimension
        tblVw.estimatedRowHeight = 100
    }
}

extension UsersHistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrJobs.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let job = arrJobs[indexPath.row]

        switch currentStatus {

        case .pending:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "OffersTableViewCell",
                for: indexPath
            ) as! OffersTableViewCell
            
            cell.imgVwUser.sd_setImage(
                with: URL(string: job.userProfile),
                placeholderImage: UIImage(named: "logo")
            )
            cell.lblUserName.text = job.userName
            cell.lblRating.text = job.userRating
            
            if let components = job.bidDate.dateComponents() {
                cell.lblDay.text = components.dayName
                cell.lblDate.text = components.day
                cell.lblMonth.text = components.month
                cell.lblYear.text = components.year
            }
            
            let result1 = job.bidTime.splitTime()
            cell.lblTime.text = result1.time
            cell.lblAMPM.text = result1.period
           
            
            
            cell.lblLocation.text = job.address
            cell.lblDetails.text = job.detail
            
            
            return cell

        case .accepted:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "InProcessTableViewCell",
                for: indexPath
            ) as! InProcessTableViewCell

            cell.imgVwUser.sd_setImage(
                with: URL(string: job.userProfile),
                placeholderImage: UIImage(named: "logo")
            )
            cell.lblUserName.text = job.userName
            cell.lblAverageRating.text = job.userRating
            cell.lblDetails.text = job.detail
            cell.lblService.text = job.subCategoryName
            cell.lblAddress.text = job.address
            
            if let components = job.bidDate.dateComponents() {
                cell.lblDay.text = components.dayName
                cell.lblDate.text = components.day
                cell.lblMonth.text = components.month
                cell.lblYear.text = components.year
            }
            
            let result1 = job.bidTime.splitTime()
            cell.lblTime.text = result1.time
            cell.lblAMPM.text = result1.period
            
            return cell

        case .completed:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CompletedTableViewCell",
                for: indexPath
            ) as! CompletedTableViewCell

            cell.imgVwUser.sd_setImage(
                with: URL(string: job.userProfile),
                placeholderImage: UIImage(named: "logo")
            )
            cell.lblUserName.text = job.userName
            cell.lblrating.text = job.userRating
            cell.lblAwatrded.text = "Completed"
            cell.lblStatus.text = job.subCategoryName
            cell.lblDetail.text = job.detail
            
            if job.dropAddress.isEmpty {
                cell.vwLocation.isHidden = true
            } else {
                cell.vwLocation.isHidden = false
            }
            
            cell.lblAddressA.text = job.address
            cell.lblAddressB.text = job.dropAddress
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let obj = arrJobs[indexPath.row]
        
        if obj.status == "Pending" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalViewController") as! ProfessionalViewController
            vc.objJobDetails = arrJobs[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobDetailViewController") as! JobDetailViewController
            vc.objJob = arrJobs[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
        
}


extension UsersHistoryViewController {

    func call_WebService_GetJobs(strStatus: String) {

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
                "user_id": objAppShareData.UserDetail.strUserId!,
                "lang": objAppShareData.currentLanguage,
                "status": self.currentStatus.rawValue,
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
                    self.refreshControl.endRefreshing()
                    self.arrJobs.reverse()
                    self.tblVw.reloadData()
                }
            } else {
                self.arrJobs.removeAll()
                self.refreshControl.endRefreshing()
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
            self.refreshControl.endRefreshing()
            print("Error \(error)")
        }
    }

}
