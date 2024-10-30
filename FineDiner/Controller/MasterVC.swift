//
//  MasterVC.swift
//  FoodDeliveryApp
//
//  Created by Hala Zyod on 12/23/20.
//

import UIKit
import BWWalkthrough

class MasterVC: BWWalkthroughViewController,BWWalkthroughViewControllerDelegate {

    @IBOutlet weak var nextBtn: UIButton!
//    @IBOutlet weak var pager: UIPageControl!
    
    var fromMainMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        guard let first = FirstVc.storyboardInstance() else {return}
        guard let second = SecondVc.storyboardInstance() else {return}
        guard let third = ThirdVc.storyboardInstance() else {return}
        
        self.add(viewController: first)
        self.add(viewController: second)
        self.add(viewController: third)
    
    
    }
    func walkthroughPageDidChange(_ pageNumber: Int) {
//        pager.currentPage = pageNumber
        self.delegate = self
        guard let first = FirstVc.storyboardInstance() else {return}
        guard let second = SecondVc.storyboardInstance() else {return}
        guard let third = ThirdVc.storyboardInstance() else {return}
        
        self.add(viewController: first)
        self.add(viewController: second)
        self.add(viewController: third)
        
    }
    
    static func storyboardInstance() -> MasterVC? {
        let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MasterVC") as? MasterVC
    }
    
    @IBAction func nextTapp(_ sender: UIButton) {
        guard let isAuth = Helper.shared.getToken() else{
            let storyboard = UIStoryboard(name: "LoginRegister", bundle: nil)
            if let nextVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
                
            }
            return
        }
        if isAuth != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let nextVC = storyboard.instantiateViewController(withIdentifier: "LocationVC") as? LocationVC {
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
                
            }
        }else{
            let storyboard = UIStoryboard(name: "LoginRegister", bundle: nil)
            if let nextVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
                
            }
        }
    }
    
    @IBAction func skipTapp(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "LoginRegister", bundle: nil)
        if let nextVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
            
        }
        
    }
}
