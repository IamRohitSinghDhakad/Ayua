//
//  UserHomeViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 18/01/26.
//

import UIKit

class UserHomeViewController: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
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
        
        
    }
    
    
    
}

extension UserHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "UserHomeTableViewCell",
            for: indexPath
        ) as! UserHomeTableViewCell
        
        
        return cell
    }
}


