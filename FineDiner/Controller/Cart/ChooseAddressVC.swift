//
//  ChooseAddressVC.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import KRProgressHUD
import Toast_Swift

class ChooseAddressVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var addressArray = [AddressModel]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getAddress()
        NotificationCenter.default.addObserver(self, selector: #selector(ReloadGetAddress), name: NSNotification.Name(rawValue: "ReloadGetAddress"), object: nil)
        
    }
    
    @objc func ReloadGetAddress() {
        getAddress()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "ChooseAddressCell", bundle: nil), forCellReuseIdentifier: "ChooseAddressCell")
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
    @IBAction func backTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
//        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as? CartVC else {return}
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: true)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if Helper.shared.addressId == ""{
            let style = ToastStyle()
            self.view.makeToast("Please select address", duration: 4.0, position: .bottom, style: style)
        }else{
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPaymentVC") as? SelectPaymentVC else {return}
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
        }
    }
    @IBAction func AddTapped(_ sender: Any) {
        Helper.shared.addressEnter = "CartAddress"
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Address", bundle: nil)
        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "AddAddressVC") as! AddAddressVC
        homePage.modalPresentationStyle = .fullScreen
        self.present(homePage, animated: true)
    }
    
    
}
extension ChooseAddressVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return addressArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseAddressCell", for: indexPath) as? ChooseAddressCell{
            cell.type.text = addressArray[indexPath.row].name as! String
            if addressArray[indexPath.row].name as! String == "Home"{
                cell.typeImg.image = UIImage(named: "Home-1")
            }else{
                cell.typeImg.image = UIImage(named: "Office")
            }
            cell.lblAddress.text = "\(addressArray[indexPath.row].street as? String ?? ""), \(addressArray[indexPath.row].building_name as? String ?? ""), \(addressArray[indexPath.row].building_number as? String ?? "")"
            
            if addressArray[indexPath.row].is_select == "no"{
                cell.radioImg.image = UIImage(named: "un-check")
            }else{
                cell.radioImg.image = UIImage(named: "check-1")
            }

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let address = addressArray[indexPath.row]
        
//        ArrayAttribut.removeAll()
        for item in addressArray{
            if item.is_select == "yes"{
                item.is_select = "no"
            }
        }
        address.is_select = "yes"
        self.tableView.reloadData()
        Helper.shared.addressId = "\(address.id as? Int ?? 0)"
        Helper.shared.addressInHome = address.name as? String ?? ""
        
    }
}

