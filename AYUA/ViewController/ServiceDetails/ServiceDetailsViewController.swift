//
//  ServiceDetailsViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 25/01/26.
//

import UIKit

class ServiceDetailsViewController: UIViewController {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var txtVw: UITextView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var lblSelectdate: UILabel!
    @IBOutlet weak var lblSelectTime: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnOnSelectDate(_ sender: Any) {
        showDatePicker(mode: .date, title: "Select Date") { [weak self] selectedDate in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM yyyy"
                self?.lblSelectdate.text = formatter.string(from: selectedDate)
            }
    }
    
    @IBAction func btnOnSelectTime(_ sender: Any) {
        showDatePicker(mode: .time, title: "Select Time") { [weak self] selectedTime in
               let formatter = DateFormatter()
               formatter.dateFormat = "hh:mm a"
               self?.lblSelectTime.text = formatter.string(from: selectedTime)
           }
    }
    
    @IBAction func btnOnSendOffer(_ sender: Any) {
    }
}

extension ServiceDetailsViewController{
    private func showDatePicker(mode: UIDatePicker.Mode,
                                title: String,
                                completion: @escaping (Date) -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: "\n\n\n\n\n\n\n",
                                      preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = mode
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 45),
            datePicker.heightAnchor.constraint(equalToConstant: 216)
        ])

                
        let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
            completion(datePicker.date)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

}
