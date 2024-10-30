//
//  ThirdVc.swift
//  FoodDeliveryApp
//
//  Created by Hala Zyod on 12/23/20.
//

import UIKit

class ThirdVc: UIViewController {

    @IBOutlet weak var walkthroughView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    static func storyboardInstance() -> ThirdVc? {
           let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
           return storyboard.instantiateViewController(withIdentifier: "ThirdVc") as? ThirdVc
       }

}
