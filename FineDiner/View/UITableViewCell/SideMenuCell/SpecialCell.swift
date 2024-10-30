//
//  SpecialCell.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 07/06/2022.
//

import UIKit

class SpecialCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var Lb: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> SpecialCell {
        
        let kCellIdentifier = "SpecialCell"
        
        tableView.register(UINib(nibName: kCellIdentifier, bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath as IndexPath) as! SpecialCell
        
        return cell
    }
    
}
