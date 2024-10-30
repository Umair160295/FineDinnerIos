//
//  GroupCell.swift
//  FineDiner
//
//  Created by iOS Developer on 19/12/2021.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var productsDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        groupView.fullDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
