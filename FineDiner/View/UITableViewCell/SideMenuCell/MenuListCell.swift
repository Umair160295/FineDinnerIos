//
//  MenuListCell.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 07/06/2022.
//

import UIKit

class MenuListCell: UITableViewCell {
    
    @IBOutlet weak var sideImageView: UIImageView!
    @IBOutlet weak var sideTitleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> MenuListCell {

           let kCellIdentifier = "MenuListCell"

           tableView.register(UINib(nibName: kCellIdentifier, bundle: nil), forCellReuseIdentifier: kCellIdentifier)

           let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath as IndexPath) as! MenuListCell

           return cell
       }

    
}
