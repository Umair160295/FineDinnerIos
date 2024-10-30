//
//  SettingsVC.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import SideMenu
import KRProgressHUD

class SettingsVC: BaseViewController {

    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var AppversionLbl: UILabel!
    var menuButtonLeft: UIBarButtonItem!
    var sideLeftVC : UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        menuBtn.addTarget(self, action: #selector(onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        sideLeftVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNavigationController")
        setUpSideMenuDefaults()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        AppversionLbl.text = "App version: \(appVersion ?? "")"

    } 
    //    SideMenu
//    @objc override func onSlideMenuButtonPressed(_ sender : UIButton){
//            if SideMenuManager.default.leftMenuNavigationController != nil {
//                self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true) {
//                }
//            }
//    }
    func setUpSideMenuDefaults() {
        SideMenuManager.default.leftMenuNavigationController = sideLeftVC as? SideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuShadowColor = UIColor.black
        SideMenuManager.default.menuShadowOpacity = 0.3
        SideMenuManager.default.menuAnimationFadeStrength = 0.28
        SideMenuManager.default.menuShadowRadius = 100
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.size.width - 100.0;
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        if SideMenuManager.default.leftMenuNavigationController != nil {
            self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true) {
            }
        }

//        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
//        self.dismiss(animated: true)
    }
    
    @IBAction func PersonalTapped(_ sender: Any) {
//        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
//        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "PersonalInfoVC") as! PersonalInfoVC
//        homePage.modalPresentationStyle = .fullScreen
//        self.present(homePage, animated: true)
        
        
        let rootVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "PersonalInfoVC")
        self.navigationController?.pushViewController(rootVC, animated: true)
    }
    
    @IBAction func ChangePasswordTapped(_ sender: Any) {
//        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
//        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "ChangePassVC") as! ChangePassVC
//        homePage.modalPresentationStyle = .fullScreen
//        self.present(homePage, animated: true)
        
        
        let rootVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ChangePassVC")
        self.navigationController?.pushViewController(rootVC, animated: true)
    }
    
    @IBAction func languageTapped(_ sender: Any) {
        guard let popup = LanguagePopup.storyboardInstance() else {return}
        self.present(popup, animated: true, completion: nil)
    }
    
    @IBAction func privacyPolicyTapped(_ sender: Any) {
        if let url = URL(string: "https://finediner.co/privacy-policy-2/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func termsOfUseTapped(_ sender: Any) {
        if let url = URL(string: "https://finediner.co/terms-and-conditions/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func returnAndRefundPolicyTapped(_ sender: Any) {
        if let url = URL(string: "https://finediner.co/refund-policy") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func btnDeleteMyAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure delete account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: { (UIAlertAction) in
            self.deleteAccount()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareAppBTn(_ sender: Any) {
        let url = URL(string: "https://apps.apple.com/jo/app/fine-diner/id1621603607")!
        let activityVC = UIActivityViewController(activityItems: [ url], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        AlertLogout(Title: "Logout", Message: "Are you ure you want to logout?")
    }
    
    func deleteAccount(){
        KRProgressHUD.show()
        NetworkManager().deleteAccount { error, isSucces, mess in
            KRProgressHUD.dismiss()
            if isSucces{
                Helper.shared.resetDefaults()
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "LoginRegister", bundle: nil)
                let homePage = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                homePage.modalPresentationStyle = .fullScreen
                self.present(homePage, animated: true)
            }
        }
    }
    
    func AlertLogout(Title:String,Message:String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            Helper.shared.resetDefaults()
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "LoginRegister", bundle: nil)
            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            homePage.modalPresentationStyle = .fullScreen
            self.present(homePage, animated: true)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


