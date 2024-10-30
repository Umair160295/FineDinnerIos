//
//  AddressVC.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import KRProgressHUD
import Toast_Swift
import SideMenu

class AddressVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!

    var addressArray = [AddressModel]()
    var menuButtonLeft: UIBarButtonItem!
    var sideLeftVC : UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getAddress()
        menuBtn.addTarget(self, action: #selector(onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        sideLeftVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNavigationController")
        setUpSideMenuDefaults()
    }
    
    //    SideMenu
    @objc override func onSlideMenuButtonPressed(_ sender : UIButton){
            if SideMenuManager.default.leftMenuNavigationController != nil {
                self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true) {
                }
            }
    }
    func setUpSideMenuDefaults() {
        SideMenuManager.default.leftMenuNavigationController = sideLeftVC as? SideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuShadowColor = UIColor.black
        SideMenuManager.default.menuShadowOpacity = 0.3
        SideMenuManager.default.menuAnimationFadeStrength = 0.28
        SideMenuManager.default.menuShadowRadius = 100
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.size.width - 100.0;
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    func getAddress(){
        KRProgressHUD.show()
        NetworkManager().getAddress{ (addressArray, mess, isSuccess) in
            KRProgressHUD.dismiss()
            if isSuccess == true{
                if addressArray.count == 0{
                    self.addressArray = []
                }else{
                    self.addressArray = addressArray
                }
                self.tableView.reloadData()
            }else {
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    @IBAction func menuTapped(_ sender: Any) {
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        Helper.shared.addressEnter = "MainAddress"
        Helper.shared.address_type = "new"
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressVC") as? AddAddressVC else {return}
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
}
extension AddressVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return addressArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as? AddressCell{
            cell.type.text = addressArray[indexPath.row].type as? String ?? "Home"
            if addressArray[indexPath.row].name as! String == "Home"{
                cell.typeImg.image = UIImage(named: "Home-1")
            }else{
                cell.typeImg.image = UIImage(named: "Office")
            }
            cell.lblAddress.text = "\(addressArray[indexPath.row].street as? String ?? ""), \(addressArray[indexPath.row].building_name as? String ?? ""), \(addressArray[indexPath.row].building_number as? String ?? "")"
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let address = addressArray[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            Helper.shared.areaId = "\(address.id as! Int)"
            self.deleteProduct()
        })
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Helper.shared.Address_Id = addressArray[indexPath.row].id as? Int ?? 0
        Helper.shared.address_type = "edit"
        Helper.shared.area_id = addressArray[indexPath.row].areaId as! Int
        Helper.shared.address_line = addressArray[indexPath.row].type as! String
        Helper.shared.bulliding_name = addressArray[indexPath.row].building_name as! String
        Helper.shared.Apartment_number =  addressArray[indexPath.row].building_number as! String
        Helper.shared.address_name = addressArray[indexPath.row].name as! String
        print(Helper.shared.Address_Id)
        print(Helper.shared.area_id)
        print(Helper.shared.address_line)
        print(Helper.shared.bulliding_name)
        print(Helper.shared.Apartment_number)
        print(Helper.shared.address_name)
        
        let rootVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddAddressVC")
        self.present(rootVC, animated: true, completion: nil)
        
//        self.navigationController?.pushViewController(rootVC, animated: true)
    }
    func deleteProduct() {
        KRProgressHUD.show()
        NetworkManager().deleteAddress(addressId: Helper.shared.areaId) { error, isSucces, mess in
            if isSucces == true{
                self.getAddress()
            }else{
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
}

