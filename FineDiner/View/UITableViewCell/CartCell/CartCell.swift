//
//  CartCell.swift
//  FineDiner
//
//  Created by iOS Developer on 24/12/2021.
//

import UIKit
import GMStepper

class CartCell: UITableViewCell {

    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var quantity: GMStepper!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var QTYlbl: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    var itemArray = [AttributesM]()
    var model:CartM!{
        didSet{
            itemArray = model.attributesArr
            tableView.reloadData()
        }
    }
    
    func setData(data: CartM){
        self.lblProductName.text = data.name as! String
        self.lblProductPrice.text = data.formatted_price as! String
        self.quantity.value = Double(data.quantity as! Int)
        self.QTYlbl.text = "\(data.quantity as! Int)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        groupView.fullDesign()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "AttributesCell", bundle: nil), forCellReuseIdentifier: "AttributesCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    
}


extension CartCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return itemArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AttributesCell", for: indexPath) as? AttributesCell{
            cell.model = itemArray[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 31
//        return CGFloat((35*itemArray.count))
    }
    
    
    
}
