//
//  ChooseAddressCell.swift
//  FineDiner
//
//  Created by iOS Developer on 24/12/2021.
//

import UIKit

class ChooseAddressCell: UITableViewCell {

    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var typeImg: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var radioImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        groupView.fullDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
