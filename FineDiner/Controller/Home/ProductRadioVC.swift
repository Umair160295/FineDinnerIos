//
//  ProductRadioVC.swift
//  FineDiner
//
//  Created by QTechnetworks on 16/02/2022.
//

import UIKit
import GMStepper
import ImagePicker
import KRProgressHUD
import Toast_Swift
import Adjust

class ProductRadioVC: UIViewController {
    
    var dataList : [ProductsDetailsM] = []
    var dataListItemMinMaxM : [ItemMinMaxM] = []
    var ArrayAttribut = [Int]()
    var ArrayAttributItem = [Int]()
    var indexMax = 0
    var minAttProduct = 0
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDes: UILabel!
    
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var stepperQ: GMStepper!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var BtnMoreDes: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let event = ADJEvent(eventToken: "i6xgwq")
        Adjust.trackEvent(event)
        Helper.shared.itemMaxArray = []
//        self.imgProduct.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.imgProduct.layer.cornerRadius = 30
        self.imgProduct.layer.masksToBounds = true
        setupTableView()
        getData()
        ArrayAttribut.removeAll()
        
//        stepperQ.cornerRadius
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "MainProductCheckboxCell", bundle: nil), forCellReuseIdentifier: "MainProductCheckboxCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getData(){
        if Helper.shared.productDes.count > 34{
            BtnMoreDes.isHidden = false
        }else{
            BtnMoreDes.isHidden = true
        }
        self.lblProductDes.text = Helper.shared.productDes
        self.lblProductName.text = Helper.shared.productName
        self.lblProductPrice.text = "\(Helper.shared.productPrice) Price Including Tax"
        let img = Helper.shared.productImage
        if img == ""{
            self.imgProduct.image = UIImage(named: "Image")
        }else{
            self.imgProduct.sd_setImage(with: URL(string: img), completed: nil)
        }
        KRProgressHUD.show()
        NetworkManager().getProductsDetails2(productsId: "\(Helper.shared.productId)") { itemMaxMin, product, mess, isSucces in
            KRProgressHUD.dismiss()
            if isSucces == true{
                self.dataList = product
                self.dataListItemMinMaxM = itemMaxMin
                Helper.shared.itemMaxMinArray = itemMaxMin as NSArray
                Helper.shared.itemSectionArray = product as NSArray
                print(self.dataListItemMinMaxM)
                self.tableView.reloadData()
            }else{
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
    func setData(){
        ArrayAttribut = Helper.shared.attributArray as! [Int]
        let parameter = ["menu_id":Helper.shared.menuId,
                         "product_id":Helper.shared.productId,
                         "quantity":stepperQ.value,
                         "product_attributes":ArrayAttribut] as [String:Any]
        print(parameter)
        KRProgressHUD.show()
        NetworkManager().postCart(param: parameter) { message, bool in
            KRProgressHUD.dismiss()
            if bool{
                HomeVC().Analytics(title: "Add_to_Cart_IOS_App")
                let event = ADJEvent(eventToken: "sgums3")
                Adjust.trackEvent(event)
                print(Helper.shared.attributArray)
                print(Helper.shared.itemMaxArray)
                Helper.shared.attributArray = []
                Helper.shared.itemMaxArray = []
                self.ArrayAttribut.removeAll()
                self.ArrayAttributItem.removeAll()
                print(Helper.shared.attributArray)
                print(Helper.shared.itemMaxArray)
//                let rootVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC")
//                self.navigationController?.pushViewController(rootVC, animated: true)
                self.navigationController?.popViewController(animated: true)
            }else{
                if message == "Product already exists"{
                    let style = ToastStyle()
                    self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
                }else{
                    self.Alert()
                }
            }
        }
    }
    
    func Alert() {
        let alertController = UIAlertController(title: "would you like to start a new order?", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(UIAlertAction(title: "DELETE", style: UIAlertAction.Style.default, handler: { _ in
            self.clearCart()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func clearCart(){
        KRProgressHUD.show()
        NetworkManager().deleteCart { message, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.setData()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }

    }
    
    func addToCart(){
        if Helper.shared.getIsLogin() == true{
            setData()
        }else{
        let message = "Please, login"
        let style = ToastStyle()
         self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
        }
//            if ArrayAttribut.count == 0{
//                let style = ToastStyle()
//                self.view.makeToast("You must select choice", duration: 4.0, position: .bottom, style: style)
//            }else{
                
//            }
    }
    
    @IBAction func btnBack(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        var minValidate = true
        var sectionNameValidate = [String]()
        var ArrayAttributItemNew = [Int]()
        indexMax = 0
        var message = ""
        print(ArrayAttributItem)
        print(Helper.shared.itemMaxArray as! [Int])
        ArrayAttributItem = Helper.shared.itemMaxArray as! [Int]
        print(ArrayAttributItem)
        print(Helper.shared.itemMaxArray as! [Int])
        var max =  0
        var min =  0
        var mId =  0
        if self.dataListItemMinMaxM.count == 0{
//            ArrayAttribut = Helper.shared.attributArray as! [Int]
            addToCart()
        }else{
            for i in dataList{
                print("\(i.name as! String): \(i.currentSelected), min \(i.min as! Int)")
                if i.currentSelected >= i.min as! Int{
                    
                }else{
//                    sectionNameValidate = ""
                    sectionNameValidate.append("\(i.name as! String)")
                    ArrayAttributItemNew.append(i.min as! Int)
                    message = message + "In section \(i.name as! String) Minimum is only \(i.min as! Int), "
                    minValidate = false
                }
            }
            if minValidate == true{
                
                addToCart()
            }else{
                Alert(Message: message)
            }
        }
    }
    
    @IBAction func btnMoreDes(_ sender: Any) {
        self.Alert1(Message: Helper.shared.productDes)
    }
    
    func Alert1 (Message: String){
        let alert = UIAlertController(title: "Description", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in

        }))
        self.present(alert, animated: true, completion: nil)
    }

    func Alert(Message: String) {
        let alertController = UIAlertController(title: "Whoops", message: Message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension ProductRadioVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = dataList[indexPath.row].ItemArray
        print((56+58*item.count))
        return CGFloat((56+50*item.count))
//            return 177
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainProductCheckboxCell", for: indexPath) as? MainProductCheckboxCell
        cell?.model = dataList[indexPath.row]
        cell?.lblTitleOption.text = dataList[indexPath.row].name as? String ?? ""
        cell?.Vc = self
        cell?.selectionStyle = .none
        cell?.btnCheckId.tag = indexPath.row
        cell?.btnCheckId.addTarget(self, action: #selector(checkId(_:)), for: .touchUpInside)
        return cell!
    }
    
    @objc func checkId(_ sender:UIButton){
        let item = dataList[sender.tag]
        print(item.id)
    }

}
