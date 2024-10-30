//
//  RateorderPopup.swift
//  FineDiner
//
//  Created by mustafa khallad on 04/02/2023.
//

import UIKit

class RateorderPopup: UIViewController {
    static func storyboardInstance() -> RateorderPopup? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "RateorderPopup") as? RateorderPopup
    }
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
   

}
