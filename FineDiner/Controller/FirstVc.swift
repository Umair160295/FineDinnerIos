//
//  FirstVc.swift
//  FoodDeliveryApp
//
//  Created by Hala Zyod on 12/23/20.
//

import UIKit

class FirstVc: UIViewController {
    
    @IBOutlet weak var walkthroughView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walkthroughView.viewDesign()
    }
  
    
    static func storyboardInstance() -> FirstVc? {
        let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FirstVc") as? FirstVc
    }
}
 
