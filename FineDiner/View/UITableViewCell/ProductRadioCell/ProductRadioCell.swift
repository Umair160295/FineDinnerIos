//
//  ProductRadioCell.swift
//  FineDiner
//
//  Created by QTechnetworks on 16/02/2022.
//

import UIKit

class ProductRadioCell: UITableViewCell {
    
    @IBOutlet weak var imgRadio: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
