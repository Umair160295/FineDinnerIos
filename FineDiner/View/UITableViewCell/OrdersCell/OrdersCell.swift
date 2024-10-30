//
//  OrdersCell.swift
//  FineDiner
//
//  Created by iOS Developer on 22/12/2021.
//

import UIKit

class OrdersCell: UITableViewCell {

    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var imgOrder: UIImageView!
    @IBOutlet weak var lblNameOrder: UILabel!
    @IBOutlet weak var lblAddressOrder: UILabel!
    @IBOutlet weak var lblPriceOrder: UILabel!
    @IBOutlet weak var lblCountItem: UILabel!
    @IBOutlet weak var lblDateOrder: UILabel!
    @IBOutlet weak var BtnStatsOrder: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        groupView.fullDesign()
    }

    func setData(data: OrderM) {
        imgOrder.sd_setImage(with: URL(string: data.iconMenu as? String ?? ""), completed: nil)
        lblNameOrder.text = data.nameMenu as? String ?? ""
        lblAddressOrder.text = data.address as? String ?? ""
        lblPriceOrder.text = data.price as? String ?? ""
        lblCountItem.text = "\(data.count_items as? Int ?? 0)"
        lblDateOrder.text = "\(data.date_order as? String ?? ""), \(data.time_order as? String ?? "")"
        BtnStatsOrder.setTitle(data.status as? String ?? "", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
