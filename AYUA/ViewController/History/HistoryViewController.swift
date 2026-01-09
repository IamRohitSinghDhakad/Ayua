//
//  HistoryViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 08/01/26.
//

import UIKit
import SDWebImage

class HistoryViewController: UIViewController {

    @IBOutlet weak var vwPending: UIView!
    @IBOutlet weak var vwAccepted: UIView!
    @IBOutlet weak var vwCompleted: UIView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var btnOnPending: UIButton!

    var arrJobs = [JobsModel]()
    private let refreshControl = UIRefreshControl()

    enum JobStatus: String {
        case pending = "Pending,Awarded"
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

    @IBAction func btnOpenSideMenu(_ sender: Any) {

    }

    @IBAction func btnPending(_ sender: Any) {
        switchTab(.pending)
    }
    @IBAction func btnAccepted(_ sender: Any) {
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
        vwPending.backgroundColor =
            currentStatus == .pending ? .primary : .white
        vwAccepted.backgroundColor =
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
            UINib(nibName: "PendingTableViewCell", bundle: nil),
            forCellReuseIdentifier: "PendingTableViewCell"
        )

        tblVw.register(
            UINib(nibName: "AcceptedTableViewCell", bundle: nil),
            forCellReuseIdentifier: "AcceptedTableViewCell"
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

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrJobs.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let job = arrJobs[indexPath.row]

        switch currentStatus {

        case .pending:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "PendingTableViewCell",
                for: indexPath
            ) as! PendingTableViewCell

            if job.status == "Awarded" {
                cell.vwServices.isHidden = true
                cell.vwUserDetails.isHidden = false
                cell.vwButtons.isHidden = false
                cell.imgVwUser.sd_setImage(
                    with: URL(string: job.providerProfile),
                    placeholderImage: UIImage(named: "logo")
                )
                cell.lblUserName.text = job.providerName
                cell.lblrating.text = job.providerRating
                
            }else{
                cell.vwUserDetails.isHidden = true
                cell.vwButtons.isHidden = true
                cell.vwServices.isHidden = false
            }
            
           
            
            
            cell.lblServiceNames.text = job.subCategoryName
            cell.lblDescription.text = job.detail
            
            // Collect images safely
               let images = [
                   job.image1,
                   job.image2,
                   job.image3,
                   job.image4
               ].filter { !$0.isEmpty }

               cell.configureImages(images)
            
            
            return cell

        case .accepted:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "AcceptedTableViewCell",
                for: indexPath
            ) as! AcceptedTableViewCell

            // configure accepted cell
            return cell

        case .completed:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CompletedTableViewCell",
                for: indexPath
            ) as! CompletedTableViewCell

            cell.imgVwUser.sd_setImage(
                with: URL(string: job.providerProfile),
                placeholderImage: UIImage(named: "logo")
            )
            cell.lblUserName.text = job.providerName
            cell.lblrating.text = job.providerRating
            cell.lblAwatrded.text = job.subCategoryName
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
    }
}


extension HistoryViewController {

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
            strURL: WsUrl.url_getJobs,
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
