//
//  AttributesCell.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 06/06/2022.
//

import UIKit

class AttributesCell: UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var lblPriceAttribut: UILabel!
    
    var model:AttributesM!{
        didSet{
            self.lbl.text = "- \(model.name as? String ?? "")"
            self.lblPriceAttribut.text = model.formatted
            if model.amount as? String ?? "" == "0"{
                self.lblPriceAttribut.isHidden = true
            }else{
                self.lblPriceAttribut.isHidden = false
            }
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
