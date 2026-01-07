//
//  HomeViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 06/01/26.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var cvCategory: UICollectionView!
    @IBOutlet weak var txtVw: RDTextView!
    private var selectedCategoryIndex: Int = 0
    @IBOutlet weak var lblSelectedServices: UILabel!
    @IBOutlet weak var imgVwOne: UIImageView!
    @IBOutlet weak var imgVwTwo: UIImageView!
    @IBOutlet weak var imgVwThree: UIImageView!
    @IBOutlet weak var imgVwFour: UIImageView!
    
    private var arrImages: [BannerModel] = []
    var arrCategory = [CategoryModel]()

       private var currentIndex: Int = 0
       private var timer: Timer?

       override func viewDidLoad() {
           super.viewDidLoad()
           setupCollectionView()
           startAutoScroll()
           call_Websercice_GetProfile()
           call_Websercice_GetBanners()
           call_WebService_GetCategory()
       }

       deinit {
           timer?.invalidate()
       }

    @IBAction func btnOpenSideMenu(_ sender: Any) {
        SideMenuManager.shared.showMenu(from: self)
    }
    
    @IBAction func btnOnFindProfessional(_ sender: Any) {
        
    }
    @IBAction func btnOpenSelectServiceType(_ sender: Any) {
        
    }
    
    @IBAction func openImageView(_ sender: UIButton) {
        MediaPicker.shared.pickMedia(from: self) { image, dict in
            switch sender.tag {
            case 1:
                self.imgVwOne.image = image
            case 2:
                self.imgVwTwo.image = image
            case 3:
                self.imgVwThree.image = image
            default:
                self.imgVwFour.image = image
            }
        }
    }
    
    @IBAction func openLoactionView(_ sender: Any) {
    }
    
}

// MARK: - Setup
extension HomeViewController {

    private func setupCollectionView() {
        cv.delegate = self
        cv.dataSource = self

        cvCategory.delegate = self
        cvCategory.dataSource = self

        
        if let layout = cv.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        if let layout = cvCategory.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }

        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
    }

    private func setupPageControl() {
        pageController.numberOfPages = arrImages.count
        pageController.currentPage = 0

        pageController.currentPageIndicatorTintColor = UIColor(named: "primary")   // active dot
        pageController.pageIndicatorTintColor = .lightGray           // inactive dots
    }
}

// MARK: - Auto Scroll
extension HomeViewController {

    private func startAutoScroll() {
        timer = Timer.scheduledTimer(
            timeInterval: 4.5,
            target: self,
            selector: #selector(autoScroll),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func autoScroll() {
        guard arrImages.count > 1 else { return }

        currentIndex += 1
        if currentIndex >= arrImages.count {
            currentIndex = 0
        }

        let indexPath = IndexPath(item: currentIndex, section: 0)
        cv.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageController.currentPage = currentIndex
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvCategory {
            return arrCategory.count
        }else{
            return arrImages.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        if collectionView == cvCategory {
            let cell = cvCategory.dequeueReusableCell(
                withReuseIdentifier: "CategoryCollectionViewCell",
                for: indexPath
            ) as! CategoryCollectionViewCell

            let obj = arrCategory[indexPath.item]
            cell.lblTitle.text = obj.name ?? ""

            let isSelected = indexPath.item == selectedCategoryIndex
            cell.configure(isSelected: isSelected, imageUrl: obj.image)

            return cell
        }else{
            let cell = cv.dequeueReusableCell(
                withReuseIdentifier: "HomeCollectionViewCell",
                for: indexPath
            ) as! HomeCollectionViewCell

            let obj = self.arrImages[indexPath.item]
            
            cell.imgvwCell.sd_setImage(with: URL(string: obj.image ?? ""), placeholderImage: UIImage(named: "logo"))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == cvCategory else { return }

        selectedCategoryIndex = indexPath.item
        cvCategory.reloadData()
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        if collectionView == cvCategory {
            let itemsPerRow: CGFloat = 4
            let spacing: CGFloat = 10

            let totalSpacing = (itemsPerRow - 1) * spacing
            let availableWidth = collectionView.frame.width - totalSpacing
            let itemWidth = availableWidth / itemsPerRow

            return CGSize(width: itemWidth, height: itemWidth + 20) // adjust height if label exists
        } else {
            // Banner collection view (existing behavior)
            return CGSize(width: collectionView.frame.width,
                          height: collectionView.frame.height)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return collectionView == cvCategory ? 10 : 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return collectionView == cvCategory ? 10 : 0
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == cv else { return }
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        currentIndex = page
        pageController.currentPage = page
    }
}



extension HomeViewController {
    
    
    func call_Websercice_GetProfile() {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = ["login_user_id":objAppShareData.UserDetail.strUserId!,
            "lang":objAppShareData.currentLanguage]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
           
            
            if status == MessageConstant.k_StatusCode{
                if let resultArray = response["result"] as? [String: Any] {
                   
                    
                }
            }else{
               
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            print("Error \(error)")
            
            
        }
    }
    
    
    func call_Websercice_GetBanners() {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = ["lang":objAppShareData.currentLanguage]as [String:Any]
        print(dictParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getBanner, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let resultArray = response["result"] as? [[String: Any]] {
                    self.arrImages.removeAll()
                    for data in resultArray {
                        let banner = BannerModel(from: data)
                        self.arrImages.append(banner)
                    }
                    
                    self.cv.reloadData()
                    self.setupPageControl()
                    
                }
            }else{
                self.arrImages.removeAll()
                self.cv.reloadData()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            print("Error \(error)")
            
            
        }
    }
    
    
    func call_WebService_GetCategory() {
           guard objWebServiceManager.isNetworkAvailable() else {
               objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
               return
           }
           
           objWebServiceManager.showIndicator()
           
           let dictParam: [String: Any] = [
               "user_id": objAppShareData.UserDetail.strUserId ?? "",
               "lang": objAppShareData.currentLanguage
           ]
           
           objWebServiceManager.requestPost(strURL: WsUrl.url_getCategory, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
               objWebServiceManager.hideIndicator()
               
               print(response)
               
               let status = response["status"] as? Int
               if status == MessageConstant.k_StatusCode,
                  let resultArray = response["result"] as? [[String: Any]] {
                   
                   self.arrCategory.removeAll()
                   
                   self.arrCategory = resultArray.map { CategoryModel(from: $0) }
                  
                   self.selectedCategoryIndex = 0
                   self.cvCategory.reloadData()



                   
               } else {
                   let message = response["message"] as? String ?? "Something went wrong"
                   objAlert.showAlert(message: message, title: "Alert", controller: self)
               }
           } failure: { error in
               objWebServiceManager.hideIndicator()
               print("❌ Error:", error)
           }
       }
    
}
    
