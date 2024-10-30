//
//  ProductCheckboxCell.swift
//  FineDiner
//
//  Created by QTechnetworks on 21/02/2022.
//

import UIKit

class ProductCheckboxCell: UITableViewCell {
    
    var itemArray = [ItemM]()
    var model:ItemM!{
        didSet{
        self.lbl.text = model.name as? String ?? ""
            if model.amount as? String ?? "" == "0"{
                self.lblPriceAttribut.isHidden = true
            }else{
                self.lblPriceAttribut.isHidden = false
            }
        self.lblPriceAttribut.text = model.formatted as? String ?? ""
        }
    }
    
    @IBOutlet weak var imgCheckbox: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var lblPriceAttribut: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
