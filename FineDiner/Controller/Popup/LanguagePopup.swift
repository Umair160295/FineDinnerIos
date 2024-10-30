//
//  LanguagePopup.swift
//  FineDiner
//
//  Created by iOS Developer on 22/12/2021.
//

import UIKit

class LanguagePopup: UIViewController {
    
    
    
    static func storyboardInstance() -> LanguagePopup? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LanguagePopup") as? LanguagePopup
    }

    
    @IBOutlet weak var popupView: UIView!{
        didSet{
            popupView.layer.shadowColor = UIColor.lightGray.cgColor
            popupView.layer.shadowOffset = CGSize(width: 0, height: 2)
            popupView.layer.shadowOpacity = 0.5
            popupView.layer.shadowRadius = 3.0
            popupView.layer.masksToBounds = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(popupDismiss))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @objc func popupDismiss(){
        self.dismiss(animated: true, completion: nil)
    }

}
