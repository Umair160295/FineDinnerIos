//
//  CartVC.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import KRProgressHUD
import Toast_Swift
import ImagePicker

class CartVC: UIViewController {
    
    
    @IBOutlet weak var coupon_typeStakview: UIStackView!
    @IBOutlet weak var coupon_typeTxt: UILabel!
    @IBOutlet weak var lblItemTotal: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var viewPromoCode: UIView!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var btnClearCart: UIButton!
    @IBOutlet weak var txtPromoCoode: UITextField!
    @IBOutlet weak var imgPromoCoodeIcon: UIImageView!
    @IBOutlet weak var btnPromoCoode: UIButton!
    @IBOutlet weak var txtOrderNote: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var imgCheckAsap: UIImageView!
    @IBOutlet weak var btnAsap: UIButton!
    @IBOutlet weak var viewEmptyCart: UIView!
    
    
    
    var dataList : [CartM] = []
    var dataListTime : [OrderTimeM] = []
    var flag = 0
    let DataPicker = UIDatePicker()
    let TimePicker = UIDatePicker()
    
    var deleted_item_id = 0
    var QTY = 0
    //    PickerView
    fileprivate var timePicker = UIPickerView() {
        didSet{
            timePicker.delegate = self
            timePicker.dataSource = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coupon_typeStakview.isHidden = true
        viewEmptyCart.isHidden = true
        HomeVC().Analytics(title: "Cart_IOS")
        setupTableView()
        getCart()
        createDataPicker()
//        createTimePicker()
        setASAP()
        orderTime()
        txtTime.inputView = timePicker
        timePicker.delegate = self
        timePicker.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCart()
    }
    func createTimePicker(){
        let timePicker = UIDatePicker()
        timePicker.locale = .current
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        timePicker.calendar = Calendar(identifier: .iso8601)
//        txtTime.inputView = timePicker
        timePicker.addTarget(self, action: #selector(doneTimePressed), for: .allEvents)
    }
    @objc func doneTimePressed(sender:UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.medium
        timeFormatter.timeStyle = DateFormatter.Style.none
        timeFormatter.dateFormat = "HH:mm"
        txtTime.text = timeFormatter.string(from: sender.date)
        Helper.shared.timeOrder = timeFormatter.string(from: sender.date)
        imgCheckAsap.image = UIImage(named: "UnCheckboxIcon")
    }
    func createDataPicker(){
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.calendar = Calendar(identifier: .iso8601)
        txtDate.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .allEvents)
    }
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtDate.text = dateFormatter.string(from: sender.date)
        Helper.shared.dateOrder = dateFormatter.string(from: sender.date)
        Helper.shared.type_time = "scheduled"
        imgCheckAsap.image = UIImage(named: "UnCheckboxIcon")
        
        txtTime.text = "\(dataListTime[0].start_time as! String)-\(dataListTime[0].end_time as! String)"
        Helper.shared.start_time_Order = dataListTime[0].start_time as! String
        Helper.shared.end_time_Order = dataListTime[0].end_time as! String
    }
    func setASAP() {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateString = df.string(from: date)
        Helper.shared.dateOrder = dateString
        df.dateFormat = "HH:mm"
        let timeString = df.string(from: date)
        Helper.shared.timeOrder = timeString
        txtDate.text = "Date"
        txtTime.text = "Time"
        imgCheckAsap.image = UIImage(named: "CheckboxIcon")
        Helper.shared.type_time = "same_time"
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getCart(){
        self.dataList = []
        print(self.dataList.count)
        KRProgressHUD.show()
        NetworkManager().getCart { cart, message, bool, delivery_price, item_price, total_price, check   in
            KRProgressHUD.dismiss()
            if bool{
                if cart.count == 0 {
                    self.coupon_typeStakview.isHidden = true
                    self.lblDiscount.text = "AED 0.00"
                }
                
                self.lblItemTotal.text = item_price
                self.lblDelivery.text = delivery_price
                self.lblGrandTotal.text = total_price
                self.dataList = cart
                print(self.dataList.count)
                self.tableView.reloadData()
                if check == "nil"{
                    self.viewEmptyCart.isHidden = false
                    self.btnClearCart.isHidden = true
                    self.btnCheckout.isEnabled = false
                    self.btnAsap.isEnabled = false
                    self.btnPromoCoode.isEnabled = false
                    self.txtTime.isEnabled = false
                    self.txtDate.isEnabled = false
                    self.txtOrderNote.isEnabled = false
                    self.txtPromoCoode.isEnabled = false
                }
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
    func orderTime(){
        KRProgressHUD.show()
        NetworkManager().getOrderTime { ordertime, message, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.dataListTime = ordertime
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    @objc func minus_cart_QTY(sender:UIButton){
        let qty = dataList[sender.tag].quantity as? Int ?? 0
        Helper.shared.productId =  dataList[sender.tag].id as? Int ?? 0
        self.QTY = qty
        if  self.QTY == 1{
            print(qty)
            print(self.QTY)
            self.deleteProduct()
        }else{
            self.QTY -= 1
            print(qty)
            print(self.QTY)
            self.editQTY()
        }
    }
    @objc func plus_cart_QTY(sender:UIButton){
        let qty = dataList[sender.tag].quantity as? Int ?? 0
        Helper.shared.productId =  dataList[sender.tag].id as? Int ?? 0
        self.QTY = qty
        self.QTY += 1
        print(qty)
        print(self.QTY)
        self.editQTY()
        
    }
    func deleteProduct() {
        KRProgressHUD.show()
        NetworkManager().deleteItemInCart { message, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.getCart()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    func editQTY(){
        var parameter : [String:Any] = [:]
            parameter = ["quantity" : self.QTY] as [String:Any]
        KRProgressHUD.show()
        NetworkManager().updateQuantity(param: parameter) { message, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.getCart()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
    }
    }
    @IBAction func btnAsap(_ sender: Any) {
        setASAP()
    }
    
    
    @IBAction func btnClearCart(_ sender: Any) {
        KRProgressHUD.show()
        NetworkManager().deleteCart { message, bool in
            KRProgressHUD.dismiss()
            if bool{
//                self.coupon_typeStakview.isHidden = true
                let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
                self.navigationController?.pushViewController(rootVC, animated: true)
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func checkoutTapped(_ sender: Any) {
        Helper.shared.promoCode = txtPromoCoode.text!
        Helper.shared.note = txtOrderNote.text!
        if Helper.shared.type_time == "same_time"{
            self.getorderid()
//            let rootVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "SelectPaymentVC")
//            self.navigationController?.pushViewController(rootVC, animated: true)
        }else{
            if Helper.shared.dateOrder == "" || Helper.shared.start_time_Order == ""{
                let style = ToastStyle()
                self.view.makeToast("Please, select date and time", duration: 4.0, position: .bottom, style: style)
            }else{
                if Helper.shared.addressId == ""{
                    let rootVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "ChooseAddressVC")
                    self.navigationController?.pushViewController(rootVC, animated: true)
                }else{
                    self.getorderid()
//                    let rootVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "SelectPaymentVC")
//                    self.navigationController?.pushViewController(rootVC, animated: true)
                }
            }
        }
    }
    
    func getorderid(){
        KRProgressHUD.show()
        let parameter = [
            "address_id" : Helper.shared.addressId,
            "payment" : "card",
            "date_order" : Helper.shared.dateOrder,
            "start_time" : Helper.shared.start_time_Order,
            "end_time" : Helper.shared.end_time_Order,
            "type_time" : Helper.shared.type_time,
            "promo_code" : Helper.shared.promoCode,
            "note" : Helper.shared.note] as [String:Any]
            NetworkManager().get_order_id(param: parameter) { order_id, bool in
                KRProgressHUD.show()
            if bool{
                print(order_id)
                Helper.shared.order_id = order_id as? Int ?? 0
                print( Helper.shared.order_id)
                let rootVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "SelectPaymentVC")
                self.navigationController?.pushViewController(rootVC, animated: true)
            }else{
                let style = ToastStyle()
                print(order_id)
                self.view.makeToast(order_id as? String ?? "", duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
    
    @IBAction func btnSubmitPromoCode(_ sender: Any) {
        let parameter = ["promo_code" : txtPromoCoode.text!]
        KRProgressHUD.show()
        NetworkManager().promoCodeApi(param: parameter) { total_priceF, sub_priceF, delivery_priceF, coupon_priceF,coupon_type, message, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.coupon_typeStakview.isHidden = false
                self.coupon_typeTxt.text = coupon_type
                self.lblItemTotal.text = sub_priceF
                self.lblDelivery.text = delivery_priceF
                self.lblGrandTotal.text = total_priceF
                self.lblDiscount.text = coupon_priceF
            }else{
                self.coupon_typeStakview.isHidden = true
                self.txtPromoCoode.text = ""
                let style = ToastStyle()
                print(message)
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
}
extension CartVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let product = dataList[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            Helper.shared.productId = product.id as! Int
            self.deleteProduct()
        })
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell{
            cell.setData(data: dataList[indexPath.row])
            cell.model = dataList[indexPath.row]
//            cell.quantity.tag = indexPath.row
//            cell.quantity.addTarget(self, action: #selector(stepperChanged(_:)), for: .valueChanged)
            cell.minusBtn.addTarget(self, action: #selector(minus_cart_QTY(sender:)), for: .touchUpInside)
            cell.minusBtn.tag = indexPath.row
            
            cell.plusBtn.addTarget(self, action: #selector(plus_cart_QTY(sender:)), for: .touchUpInside)
            cell.plusBtn.tag = indexPath.row
            
            
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let item = dataList[indexPath.row].attributesArr
        print(120+25*item.count)
        return CGFloat((120+25*item.count))
    }
    
    @objc func stepperChanged(_ sender: UIStepper){
        print(Helper.shared.productId)
        print(self.deleted_item_id)
        print(dataList.count)
        print(dataList)
        print(dataList[0])
//        if Helper.shared.productId == self.deleted_item_id{
            
            let product = dataList[sender.tag].id
             Helper.shared.productId = product as? Int ?? 0
             let Stepper = sender.value
             print(Stepper)
             if Stepper == 0{
                 self.deleteProduct()
             }else{
                 print(Helper.shared.productId)
                 var parameter : [String:Any] = [:]
                     parameter = ["quantity" : Int(Stepper)] as [String:Any]
                 KRProgressHUD.show()
                 NetworkManager().updateQuantity(param: parameter) { message, bool in
                     KRProgressHUD.dismiss()
                     if bool{
                         print(self.dataList.count)
                         self.getCart()
                     }else{
                         let style = ToastStyle()
                         self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
                     }
                 }
             }
        }
    
}


extension CartVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return dataListTime.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        txtTime.text = "\(dataListTime[row].start_time as! String)-\(dataListTime[row].end_time as! String)"
        txtDate.text = Helper.shared.dateOrder
        Helper.shared.start_time_Order = dataListTime[row].start_time as! String
        Helper.shared.end_time_Order = dataListTime[row].end_time as! String
        Helper.shared.type_time = "scheduled"
        imgCheckAsap.image = UIImage(named: "UnCheckboxIcon")
        return "\(dataListTime[row].start_time as! String)-\(dataListTime[row].end_time as! String)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtTime.text = "\(dataListTime[row].start_time as! String)-\(dataListTime[row].end_time as! String)"
        txtDate.text = Helper.shared.dateOrder
        Helper.shared.start_time_Order = dataListTime[row].start_time as! String
        Helper.shared.end_time_Order = dataListTime[row].end_time as! String
        Helper.shared.type_time = "scheduled"
        imgCheckAsap.image = UIImage(named: "UnCheckboxIcon")
    }
    
}
