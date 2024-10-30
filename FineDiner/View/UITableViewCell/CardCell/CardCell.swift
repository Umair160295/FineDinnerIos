//
//  CardCell.swift
//  FineDiner
//
//  Created by mustafa khallad on 24/10/2022.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var deletecardBtn: UIButton!
    @IBOutlet weak var FrameView: UIView!
    @IBOutlet weak var CardNumberLbl: UILabel!
    @IBOutlet weak var CardNameLbl: UILabel!
    @IBOutlet weak var RadioBtn: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
