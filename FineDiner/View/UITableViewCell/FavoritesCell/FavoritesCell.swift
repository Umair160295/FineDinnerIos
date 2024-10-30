//
//  FavoritesCell.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import SDWebImage

class FavoritesCell: UITableViewCell {

    @IBOutlet weak var groupView: UIView!
    
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblNameMenu: UILabel!
    @IBOutlet weak var lblDescriptionMenu: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        groupView.fullDesign()
    }
    
    func setData(data: FavoritesM) {
        self.imgMenu.sd_setImage(with: URL(string: data.icon as? String ?? ""), completed: nil)
        lblNameMenu.text = data.name as? String ?? ""
        lblDescriptionMenu.text = data.description as? String ?? ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
