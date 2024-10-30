//
//  MainProductCheckboxCell.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 25/04/2022.
//

import UIKit
import Toast_Swift
import KRProgressHUD
class MainProductCheckboxCell: UITableViewCell {
    
    var itemArray = [ItemM]()
    var itemMaxMinArray = [ItemMinMaxM]()
    var itemSection = [ProductsDetailsM]()
    var Vc : ProductRadioVC?
    var ArrayAttribut = [Int]()
    var ArrayItemMax = [Int]()
    
    var model:ProductsDetailsM!{
        didSet{
            itemArray = model.ItemArray
            tableView.reloadData()
        }
    }
    
    var indexMax = 0
    var count = 1
    private var localTimer = Timer()
    @IBOutlet weak var lblTitleOption: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCheckId: UIButton!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        itemMaxMinArray = Helper.shared.itemMaxMinArray as! [ItemMinMaxM]
        itemSection = Helper.shared.itemSectionArray as! [ProductsDetailsM]
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "ProductCheckboxCell", bundle: nil), forCellReuseIdentifier: "ProductCheckboxCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}


extension MainProductCheckboxCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemSize = itemArray[indexPath.row].name as? String ?? ""
        let hight = CGFloat((itemSize.count))
        print(hight)
//        if hight < 50.0{
//            return 60
//        }
//        return hight
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCheckboxCell", for: indexPath) as? ProductCheckboxCell
        cell?.model = itemArray[indexPath.row]
        cell?.selectionStyle = .none
//        if Helper.shared.productType == "product"{
//            if dataList[indexPath.row].is_select == "no"{
//                cell?.imgRadio.image = UIImage(named: "RadioOutIcon")
//            }else{
//                cell?.imgRadio.image = UIImage(named: "RadioInIcon")
//            }
//        }else{
            if itemArray[indexPath.row].is_select == "no"{
                cell?.imgCheckbox.image = UIImage(named: "UnCheckboxIcon")
            }else{
                cell?.imgCheckbox.image = UIImage(named: "CheckboxIcon")
            }
////        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCheckboxCell", for: indexPath) as? ProductCheckboxCell
        ArrayAttribut = Helper.shared.attributArray as! [Int]
        ArrayItemMax = Helper.shared.itemMaxArray as! [Int]
        let Attribut = itemArray[indexPath.row]
//        let ItemSection2 = itemSection[indexPath.row]
        let ArrayAttributId = [Attribut.id as? Int ?? 0]
        let ArrayItemId = [Attribut.product_id as? Int ?? 0]
        let ItemId = Attribut.product_id as? Int ?? 0
        var max =  0
        var min =  0
        var mId =  0
        KRProgressHUD.show()
        localTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){(Timer) in
            self.count -= 1
            if self.count == 0 {
                KRProgressHUD.dismiss()
                self.count = 1
                self.localTimer.invalidate()
            }
        }
        let countOfItem = ArrayItemMax.filter({ $0 == ItemId }).count
            for i in itemMaxMinArray{
                 max = itemMaxMinArray[indexMax].max as? Int ?? 0
                 min = itemMaxMinArray[indexMax].min as? Int ?? 0
                 mId = itemMaxMinArray[indexMax].id as? Int ?? 0
                print("indexMax\(indexMax)")
                print("min\(min)")
                print("max\(max)")
                print(i.id as! Int)
                print(ItemId)
                if i.id as! Int == ItemId{
                    if Attribut.is_select == "no"{
                        checkMinMax()
                        }else{
                            DeleteCheck()
                        }
                    indexMax = 0
                    break
                }else{
                    indexMax += 1
                }
            }
        func checkMinMax(){
            var message = ""
            print("indexMax2\(indexMax)")
            print("min2\(min)")
            print("max2\(max)")
            if min == 0 && max == 0{
                addValue()
            }else if min == 0 && max > 0{
                if max <= countOfItem{
                    message = "Maximum is only \(max)"
                    Alert(Message: message)
                }else{
                    addValue()
                }
            }else if min > 0 && max == 0{
                addValue()
            }else{
                if max <= countOfItem{
//                    message = "maximum is \(max)"
//                    Alert(Message: message)
                    var id = 0
                    for item in ArrayItemMax {
                        for item2 in ArrayItemId{
                            if item == item2{
                                print(Attribut.id as? Int ?? 0)  // 106
                                print(ArrayAttributId)           // [106]
                                print(ArrayAttribut)             // [105]
                                ArrayAttribut.remove(at: id)
                                ArrayItemMax.remove(at: id)
                                for check in itemArray{
                                    check.is_select = "no"
                                    for i in itemSection{
                                        if i.id as! Int == Attribut.product_id as! Int {
                                            i.currentSelected = 0
                                        }
                                        print("\(i.name as! String): \(i.currentSelected)")
                                    }
                                }
                            }
                        }
                        id += 1
                    }
                    addValue()
                }else{
                    addValue()
                }
            }
        }
        func addValue(){
            print(Attribut.is_select)
            if Attribut.is_select == "no"{
                    AddCheck()
               
                }else{
                    DeleteCheck()

                }
        }
        func DeleteCheck(){
            
            var id = 0
            for item in ArrayAttribut {
                print(item)
                print(Attribut.id as? Int ?? 0)
                if item == Attribut.id as? Int ?? 0{
                    print(Attribut.id as? Int ?? 0)
                    print(ArrayAttributId)
                    print(ArrayAttribut)
                    ArrayAttribut.remove(at: id)
                    ArrayItemMax.remove(at: id)
                    Attribut.is_select = "no"
                    
                    for i in itemSection{
                        if i.id as! Int == Attribut.product_id as! Int {
                            i.currentSelected -= 1
                            print("\(i.name as! String): \(i.currentSelected)")
                        }
                    }
                }
                id += 1
            }

            
        }
        func AddCheck(){
           
            Attribut.is_select = "yes"
            for i in itemSection{
                if i.id as! Int == Attribut.product_id as! Int {
                    i.currentSelected += 1
                }
                print("\(i.name as! String): \(i.currentSelected)")
            }

            print(ArrayAttributId)
            print(ArrayAttribut)

            print(ArrayAttributId)
            print(ArrayAttribut)
            ArrayAttribut.append(contentsOf: ArrayAttributId)
            ArrayItemMax.append(contentsOf: ArrayItemId)
           
            print(ArrayAttributId)
            print(ArrayAttribut)
            
            
        }
        self.tableView.reloadData()
        print(Helper.shared.attributArray)
        print(Helper.shared.itemMaxArray)
        print(ArrayAttribut)
        print(ArrayItemMax)
        
        Helper.shared.attributArray = ArrayAttribut as NSArray
        Helper.shared.itemMaxArray = ArrayItemMax as NSArray
        
        print(Helper.shared.attributArray)
        print(Helper.shared.itemMaxArray)

    }
    
    func Alert(Message: String) {
        let alertController = UIAlertController(title: "Whoops", message: Message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        Vc?.present(alertController, animated: true, completion: nil)
    }
    
}
