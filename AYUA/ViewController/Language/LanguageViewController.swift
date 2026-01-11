//
//  LanguageViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 08/01/26.
//

import UIKit

class LanguageViewController: UIViewController {

    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblSpanish: UILabel!
    @IBOutlet weak var imgVwSelectEnglish: UIImageView!
    @IBOutlet weak var imgVwSpanishSelect: UIImageView!
    
    // Track selected language code
    var selectedLanguage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide all tick images initially
        hideAllTicks()
        loadCurrentLanguage()
    }
    
    
    // MARK: - Helper Methods
    
    private func hideAllTicks() {
        imgVwSelectEnglish.isHidden = true
        imgVwSpanishSelect.isHidden = true
    }
    
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        SideMenuManager.shared.showMenu(from: self)
    }
    
    private func loadCurrentLanguage() {
        selectedLanguage = objAppShareData.currentLanguage
        updateTickForSelectedLanguage()
    }
    
    private func updateTickForSelectedLanguage() {
        hideAllTicks()
        switch selectedLanguage {
        case "en":
            imgVwSelectEnglish.isHidden = false
        case "es":
            imgVwSpanishSelect.isHidden = false
        default:
            break
        }
    }
    
    
    
    @IBAction func btnLanguageSelect(_ sender: UIButton) {
        
        switch sender.tag {
              case 0:
                  selectedLanguage = "en"
              case 1:
                  selectedLanguage = "es"
              default:
                  return
              }

              updateTickForSelectedLanguage()
    }
    
    @IBAction func btnOnSelect(_ sender: Any) {
        guard let lang = selectedLanguage,
                     lang != objAppShareData.currentLanguage else { return }

               let alert = UIAlertController(
                   title: "Change Language",
                   message: "Do you want to change the language? The app may restart to apply changes.",
                   preferredStyle: .alert
               )

               alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
               alert.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                   self?.applyLanguage(lang)
               })

               present(alert, animated: true)
    }
    
    private func applyLanguage(_ lang: String) {
           objAppShareData.currentLanguage = lang

           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
               self.restartApp()
           }
       }
    
    private func changeLanguage(to lang: String) {
        // Update shared language
        objAppShareData.currentLanguage = lang
        selectedLanguage = lang
        
        // Update tick UI
        updateTickForSelectedLanguage()
        
        // Restart app after short delay to apply changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.restartApp()
        }
    }
    
    private func restartApp() {
        // Get the active window scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window.rootViewController = storyboard.instantiateInitialViewController()
            window.makeKeyAndVisible()
        }
    }

}
