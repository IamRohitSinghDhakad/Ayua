//
//  HomeViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 06/01/26.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    private var images: [UIImage] = [
           UIImage(named: "banner")!,
           UIImage(named: "banner")!,
           UIImage(named: "banner")!,
           UIImage(named: "banner")!
       ]

       private var currentIndex: Int = 0
       private var timer: Timer?

       override func viewDidLoad() {
           super.viewDidLoad()
           setupCollectionView()
           setupPageControl()
           startAutoScroll()
       }

       deinit {
           timer?.invalidate()
       }

    @IBAction func btnOpenSideMenu(_ sender: Any) {
    }
    
}

// MARK: - Setup
extension HomeViewController {

    private func setupCollectionView() {
        cv.delegate = self
        cv.dataSource = self

        if let layout = cv.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }

        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
    }

    private func setupPageControl() {
        pageController.numberOfPages = images.count
        pageController.currentPage = 0

        pageController.currentPageIndicatorTintColor = .green   // active dot
        pageController.pageIndicatorTintColor = .lightGray           // inactive dots
    }
}

// MARK: - Auto Scroll
extension HomeViewController {

    private func startAutoScroll() {
        timer = Timer.scheduledTimer(
            timeInterval: 2.5,
            target: self,
            selector: #selector(autoScroll),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func autoScroll() {
        guard images.count > 1 else { return }

        currentIndex += 1
        if currentIndex >= images.count {
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
        images.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HomeCollectionViewCell",
            for: indexPath
        ) as! HomeCollectionViewCell

        cell.imgvwCell.image = images[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        currentIndex = page
        pageController.currentPage = page
    }
}
