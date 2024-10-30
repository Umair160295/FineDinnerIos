//
//  ProductCell.swift
//  FineDiner
//
//  Created by iOS Developer on 20/12/2021.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        addView.bottomRightDesign()
        productView.fullDesign()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
