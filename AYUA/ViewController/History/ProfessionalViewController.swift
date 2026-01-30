//
//  ProfessionalViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 11/01/26.
//

import UIKit
import SDWebImage

class ProfessionalViewController: UIViewController {
    @IBOutlet weak var tblVw: UITableView!
    
    var objJobDetails: JobsModel?
    var arrBidProposalModel = [BidProposalModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        self.call_WebService_GetJobs(strJobID: objJobDetails?.jobId ?? "")
    }
   
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    
}


extension ProfessionalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBidProposalModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessionalTableViewCell") as!  ProfessionalTableViewCell
        
        let obj = arrBidProposalModel[indexPath.row]
        
        cell.imgVwUser.sd_setImage(with: URL(string: obj.providerProfile ?? ""), placeholderImage: UIImage(named: "logo"))
        cell.lblUserName.text = obj.providerName
        cell.lblServices.text = "(\(obj.completedJobs ?? "") Services)"
        cell.lblDate.text = "\(obj.date ?? "") \(obj.time ?? "")"
        cell.lblBidPrice.text = "\(obj.price ?? 0.0)"
         
        
        cell.btnOnChat.tag = indexPath.row
        cell.btnOnChat.addTarget(self, action: #selector(btnOnChatTapped(_:)), for: .touchUpInside)
        
        cell.btnOnAward.tag = indexPath.row
        cell.btnOnAward.addTarget(self, action: #selector(btnOnAwardTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arrBidProposalModel[indexPath.row]
        
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "UsersReviewViewController")as! UsersReviewViewController
        vc.provideID = obj.providerId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnOnChatTapped(_ sender: UIButton) {
        let index = sender.tag
        let selectedObj = arrBidProposalModel[index]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController")as! ChatDetailViewController
        vc.strReceiverId = selectedObj.id ?? ""
        vc.strSenderId = selectedObj.providerId ?? ""
        vc.strJobId = selectedObj.jobId ?? ""
        vc.strUsername = selectedObj.providerName ?? ""
        //vc.isBlocked = selectedObj.strBlocked
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnOnAwardTapped(_ sender: UIButton) {
        let index = sender.tag
        let selectedObj = arrBidProposalModel[index]
        
    }

}


extension ProfessionalViewController {
    
    func call_WebService_GetJobs(strJobID: String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = [
            "job_id": strJobID,
            "lang": objAppShareData.currentLanguage
        ]as [String:Any]
        
        print(dictParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_get_bids, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            if status == MessageConstant.k_StatusCode{
                if let resultArray = response["result"] as? [[String: Any]] {
                    print(response)
                    self.arrBidProposalModel.removeAll()
                    for data in resultArray{
                        let obj = BidProposalModel(from: data)
                        self.arrBidProposalModel.append(obj)
                    }
                    
                    if self.arrBidProposalModel.count == 0{
                        self.tblVw.displayBackgroundText(text: "No Proposal Available", fontStyle: "ABeeZee-Regular", fontSize: 22)
                    }else {
                        self.tblVw.displayBackgroundText(text: "")
                    }
                   self.tblVw.reloadData()
                }
            }else{
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                if self.arrBidProposalModel.count == 0{
                    self.tblVw.displayBackgroundText(text: "No offer found", fontStyle: "ABeeZee-Regular", fontSize: 22)
                }else {
                    self.tblVw.displayBackgroundText(text: "")
                }
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            print("Error \(error)")
        }
    }
}

