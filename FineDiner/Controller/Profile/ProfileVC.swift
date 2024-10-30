//
//  ProfileVC.swift
//  FineDiner
//
//  Created by iOS Developer on 22/12/2021.
//

import UIKit
import SideMenu


class ProfileVC: BaseViewController {

    @IBOutlet weak var menuBtn: UIButton!
    
    var menuButtonLeft: UIBarButtonItem!
    var sideLeftVC : UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self, action: #selector(onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        sideLeftVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNavigationController")
        setUpSideMenuDefaults()
    }
    
    //    SideMenu
    @objc override func onSlideMenuButtonPressed(_ sender : UIButton){
            if SideMenuManager.default.leftMenuNavigationController != nil {
                self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true) {
                }
            }
    }
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
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
    }
    @IBAction func personalInfoTapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInfoVC") as? PersonalInfoVC else {return}
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
  
    @IBAction func changeEmailTapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeEmailVC") as? ChangeEmailVC else {return}
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    
    @IBAction func changePassTapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassVC") as? ChangePassVC else {return}
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    
    @IBAction func langTapped(_ sender: Any) {
        guard let popup = LanguagePopup.storyboardInstance() else {return}
        self.present(popup, animated: true, completion: nil)
    }
}
