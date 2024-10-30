//
//  ImageViewHeaderCell.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 07/06/2022.
//

import UIKit

class ImageViewHeaderCell: UITableViewCell {
    
    @IBOutlet weak var ImageUser: UIImageView!
    @IBOutlet weak var LblName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
         SetData()
    }
    
    override func prepareForReuse() {
        SetData()
    }
    
    func SetData() {
        let profileImg = Helper.shared.getUserAvatar() ?? ""
        if profileImg == ""{
            self.ImageUser.image = UIImage(named: "Logo-1")
        }else{
            self.ImageUser.sd_setImage(with: URL(string: profileImg), completed: nil)
        }
        LblName.text = Helper.shared.getUserName()
    }

    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> ImageViewHeaderCell {

          let kCellIdentifier = "ImageViewHeaderCell"

          tableView.register(UINib(nibName: kCellIdentifier, bundle: nil), forCellReuseIdentifier: kCellIdentifier)

          let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath as IndexPath) as! ImageViewHeaderCell

          return cell
      }
    
}
