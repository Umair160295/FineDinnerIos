//
//  NotificationCell.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import SDWebImage

class NotificationCell: UITableViewCell {

    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblNameNotification: UILabel!
    @IBOutlet weak var lblDescriptionNotification: UILabel!
    
    func setData(data: NotificationM) {
        let img = data.icon as? String ?? ""
        if img == ""{
            self.imgNotification.image = UIImage(named: "Image-3")
        }else{
            self.imgNotification.sd_setImage(with: URL(string: img), completed: nil)
        }
        lblNameNotification.text = data.name as? String ?? ""
        lblDescriptionNotification.text = data.description as? String ?? ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        groupView.fullDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
