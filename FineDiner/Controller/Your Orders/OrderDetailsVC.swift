//
//  OrderDetailsVC.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import KRProgressHUD
import Toast_Swift

class OrderDetailsVC: UIViewController {

    
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblNameMenu: UILabel!
    @IBOutlet weak var lblAddressCityOrder: UILabel!
    @IBOutlet weak var btnStatusOrder: UIButton!
    @IBOutlet weak var lblItemTotal: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblPaymentOrder: UILabel!
    @IBOutlet weak var lblDatOrder: UILabel!
    @IBOutlet weak var lblStartTimeOrder: UILabel!
    @IBOutlet weak var lblEndTimeOrder: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblItemCount: UILabel!
    
    @IBOutlet weak var ordernameLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }
    
    func getData(){
        KRProgressHUD.show()
        NetworkManager().getOrderDetalis { id, payment, status, dateTime, startTime, endTime, addressOrder, phone_number, nameMenu, iconMenu, total_priceF, sub_priceF, delivery_priceF,ordername,message, bool in
            KRProgressHUD.dismiss()
            if bool{
                print(ordername)
                self.imgMenu.sd_setImage(with: URL(string: iconMenu), completed: nil)
                self.lblNameMenu.text = nameMenu
                self.lblAddressCityOrder.text = addressOrder
                self.btnStatusOrder.setTitle(status, for: .normal)
                if status == "cancelled" || status == "falied" || status == "refunded" {
                    self.btnStatusOrder.setTitleColor(.red, for: .normal)
                }else if status == "processing"{
                    self.btnStatusOrder.setTitleColor(.green, for: .normal)
                }else if status == "preparing"{
                    self.btnStatusOrder.setTitleColor(.blue, for: .normal)
                }else if status == "delivered"{
                    self.btnStatusOrder.setTitleColor(.black, for: .normal)
             }else{
                 self.btnStatusOrder.setTitleColor(.green, for: .normal)
                 
                }
                self.lblItemTotal.text = sub_priceF
                self.lblDelivery.text = delivery_priceF
                self.lblGrandTotal.text = total_priceF
                self.lblOrderNumber.text = "\(id)"
                self.lblPaymentOrder.text = payment
                self.lblDatOrder.text = dateTime
                self.lblStartTimeOrder.text = startTime
                self.lblEndTimeOrder.text = endTime
                self.lblPhone.text = phone_number
                self.lblAddress.text = addressOrder
                self.lblItemCount.text = "\(Helper.shared.countProductOfYourOrder)X"
                self.ordernameLbl.text = ordername
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 1.5, position: .bottom, style: style)
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
//        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "YourOrdersVC") as? YourOrdersVC else {return}
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: true)
        self.navigationController?.popViewController(animated: true)
    }

}
