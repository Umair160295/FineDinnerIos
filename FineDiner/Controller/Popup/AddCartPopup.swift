//
//  FriendRequestSentVc.swift
//  Flash-App
//
//  Created by Mohamed Khalil on 7/10/19.
//  Copyright © 2019 Mohamed Khalil. All rights reserved.
//

import UIKit
import GMStepper
import ImagePicker
import KRProgressHUD
import Toast_Swift


class AddCartPopup: UIViewController {
    
    
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var stepper: GMStepper!
    
    var VC = GroupDetailsVC()
    
    var friendName:String?{
        didSet{

        }
    }
    
    static func storyboardInstance() -> AddCartPopup? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AddCartPopup") as? AddCartPopup
    }

    @IBOutlet weak var messText: UILabel!
    
    @IBOutlet weak var popupView: UIView!{
        didSet{
            popupView.layer.shadowColor = UIColor.lightGray.cgColor
            popupView.layer.shadowOffset = CGSize(width: 0, height: 2)
            popupView.layer.shadowOpacity = 0.5
            popupView.layer.shadowRadius = 3.0
            popupView.layer.masksToBounds = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(popupDismiss))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        self.lblProductName.text = Helper.shared.productName
//        self.lblProductPrice.text = Helper.shared.productPrice
//        imgProduct.sd_setImage(with: URL(string: Helper.shared.productImage), completed: nil)
    }
    
    @objc func popupDismiss(){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addToCartTapped(_ sender: Any) {
        addToCart()
    }
    
    
    func addToCart(){
        let parameter = ["menu_id":Helper.shared.menuId,
                         "product_id":Helper.shared.productId,
                         "quantity":stepper.value,
                         "product_attributes":[]] as [String:Any]
        KRProgressHUD.show()
        NetworkManager().postCart(param: parameter) { message, bool in
            KRProgressHUD.dismiss()
            if bool{
//                self.VC.productCountlbl.text = "\(Helper.shared.itemCountInPopupCart) ITEM"
//                self.VC.priceLbl.text = "\(Helper.shared.itemtTotalCurrencyInPopupCart) \(Helper.shared.itemtTotalPriceInPopupCart)"
                self.dismiss(animated: true, completion: nil)
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
        
    }
    
}
