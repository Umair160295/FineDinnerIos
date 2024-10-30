//
//  ReviewsCell.swift
//  FineDiner
//
//  Created by iOS Developer on 24/12/2021.
//

import UIKit
import Cosmos
import SDWebImage

class ReviewsCell: UITableViewCell {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var cosmocView: CosmosView!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var imgUser: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data: ReviewM) {
        self.imgUser.layer.borderWidth = 2
        self.imgUser.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        let img = data.avatar as? String ?? ""
        if img == ""{
            self.imgUser.image = UIImage(named: "Person")
        }else{
            self.imgUser.sd_setImage(with: URL(string: img), completed: nil)
        }
        self.lblUserName.text = data.userName as? String ?? ""
        self.txtComment.text = data.comment as? String ?? "No comment"
        self.cosmocView.rating = Double(data.rate as? Int ?? 0)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
