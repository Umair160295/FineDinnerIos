//
//  SeparatorCell.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 07/06/2022.
//

import UIKit

class SeparatorCell: UITableViewCell {
    
    @IBOutlet weak var sepratorView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> SeparatorCell {
           
           let kCellIdentifier = "SeparatorCell"
           
           tableView.register(UINib(nibName: kCellIdentifier, bundle: nil), forCellReuseIdentifier: kCellIdentifier)
           
           let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath as IndexPath) as! SeparatorCell
           
           return cell
       }
    
}
