//
//  SideMenuVC.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 07/06/2022.
//

import Foundation
import UIKit
import SideMenu
import Alamofire
import Toast_Swift
import FacebookLogin
enum CellType {
    case Image
    case SimpleCell
    case Separator
    case emptyCell
    case specialCell
}

class SideMenuObject {
    
    var title = ""
    var image:UIImage?
    var isSelected = false
    var cellType = CellType.Image
}


class SideMenuVC: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var viewtable: UIView!
    

    var sideMenuList = [SideMenuObject]()
    let message = "Please, login"
    let style = ToastStyle()
    
    enum cellHeights : CGFloat {
        case homeCell = 220
        case normalCell = 44
        case normalCell2 = 60
        case specialCell = 25
        case separator = 1
        case emptyCell = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.table.separatorStyle = .none
        self.table.delegate = self
        self.table.dataSource = self
        setShadowView1()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        self.table.separatorStyle = .none
        self.table.delegate = self
        self.table.dataSource = self
        SetupUserMenu()
        setShadowView1()
    }
    
    func setShadowView1(){
        self.viewtable.layer.masksToBounds = true
//        self.layer.cornerRadius = 10
//        self.view1.layer.cornerRadius = 10
        self.viewtable.layer.shadowColor = UIColor.lightGray.cgColor
        self.viewtable.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.viewtable.layer.shadowOpacity = 0.6
        self.viewtable.layer.shadowRadius = 5.0
    }
    
    
    func SetupUserMenu(){
        sideMenuList = []
        let object = SideMenuObject()
        object.title = "Logo"
        object.cellType = .Image
        sideMenuList.append(object)
        let object1 = SideMenuObject()
        object1.cellType = .Separator
//        sideMenuList.append(object1)
        
        
//   1
        let HomeObject = SideMenuObject()
        HomeObject.title = "Home"
        HomeObject.cellType = .SimpleCell
        HomeObject.image = UIImage(named: "Home")
        sideMenuList.append(HomeObject)
//        sideMenuList.append(object1)

        
        
//   2
        let OrdersObject = SideMenuObject()
        OrdersObject.title = "Your Orders"
        OrdersObject.cellType = .SimpleCell
        OrdersObject.image = UIImage(named: "Your Orders")
        sideMenuList.append(OrdersObject)
//        sideMenuList.append(object1)
        
        
        
        
//   3
        let NotificationsObject = SideMenuObject()
        NotificationsObject.title = "Notifications"
        NotificationsObject.image = UIImage(named: "Notifications")
        NotificationsObject.cellType = .SimpleCell
        sideMenuList.append(NotificationsObject)
//        sideMenuList.append(object1)
        
        
        
        
//   4
        let FavoritesObject = SideMenuObject()
        FavoritesObject.title = "Favorites"
        FavoritesObject.image = UIImage(named: "Favorites")
        FavoritesObject.cellType = .SimpleCell
        sideMenuList.append(FavoritesObject)
//        sideMenuList.append(object1)
        
        
        
        
//   5
        let AddressObject = SideMenuObject()
        AddressObject.title = "Address"
        AddressObject.image = UIImage(named: "Address")
        AddressObject.cellType = .SimpleCell
        sideMenuList.append(AddressObject)
//        sideMenuList.append(object1)
        
        
        
//   6
        if Helper.shared.getIsLogin() == true{
            let SettingsObject = SideMenuObject()
            SettingsObject.title = "Settings"
            SettingsObject.image = UIImage(named: "Settings")
            SettingsObject.cellType = .SimpleCell
            sideMenuList.append(SettingsObject)
                    sideMenuList.append(object1)
            
            let LogoutObject = SideMenuObject()
            LogoutObject.title = "Log Out"
            LogoutObject.image = UIImage(named: "LogoutIcon")
            LogoutObject.cellType = .SimpleCell
            sideMenuList.append(LogoutObject)
                    sideMenuList.append(object1)
        }else{
            let SettingsObject = SideMenuObject()
            SettingsObject.title = "Log In"
            SettingsObject.image = UIImage(named: "LogoutIcon")
            SettingsObject.cellType = .SimpleCell
            sideMenuList.append(SettingsObject)
                    sideMenuList.append(object1)
        }
       
//   7
//        let HelpObject = SideMenuObject()
//        HelpObject.title = "Open from 8 am to 11 pm"
//        HelpObject.cellType = .specialCell
//        sideMenuList.append(HelpObject)
////   8
//        let Help2Object = SideMenuObject()
//        Help2Object.title = "for help reach us over"
//        Help2Object.cellType = .specialCell
//        sideMenuList.append(Help2Object)
////   9
//        let Help3Object = SideMenuObject()
//        Help3Object.title = "phone or whatsapp"
//        Help3Object.cellType = .specialCell
//        sideMenuList.append(Help3Object)
//   10
//        let Help4Object = SideMenuObject()
//        Help4Object.title = "054 372 1170"
//        Help4Object.cellType = .specialCell
//        sideMenuList.append(Help4Object)
        
        let Help4Object = SideMenuObject()
        Help4Object.title = "Whatsapp"
        Help4Object.image = UIImage(named: "whatsapp_icon")
        Help4Object.cellType = .SimpleCell
        sideMenuList.append(Help4Object)
//                sideMenuList.append(object1)


        
        self.table.reloadData()
    }

    
    
}

extension SideMenuVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
                        switch indexPath.row {
                        case 1:
                            let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
                            self.navigationController?.pushViewController(rootVC, animated: true)
                            
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let controller = storyboard.instantiateViewController(withIdentifier: "NavHomeVC")
//                            controller.modalPresentationStyle = .fullScreen
//                            self.present(controller, animated: true, completion: nil)
                            
                        case 2:
                            if Helper.shared.getIsLogin() == true{
                                let rootVC = UIStoryboard(name: "Your Orders", bundle: nil).instantiateViewController(withIdentifier: "YourOrdersVC")
                                self.navigationController?.pushViewController(rootVC, animated: true)
                            }else{
                                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
                            }
                            
//                            let storyboard = UIStoryboard(name: "TravelHistory", bundle: nil)
//                            let controller = storyboard.instantiateViewController(withIdentifier: "TravelHistoryVC")
//                            controller.modalPresentationStyle = .fullScreen
//                            self.present(controller, animated: true, completion: nil)
                            
                        case 3:
                            if Helper.shared.getIsLogin() == true{
                                let rootVC = UIStoryboard(name: "Notifications", bundle: nil).instantiateViewController(withIdentifier: "NotificationsVC")
                                self.navigationController?.pushViewController(rootVC, animated: true)
                            }else{
                                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
                            }
                            
//                            let storyboard = UIStoryboard(name: "Notifications", bundle: nil)
//                            let controller = storyboard.instantiateViewController(withIdentifier: "NotificationsVC")
//                            controller.modalPresentationStyle = .fullScreen
//                            self.present(controller, animated: true, completion: nil)
                            
                        case 4:
                            if Helper.shared.getIsLogin() == true{
                                let rootVC = UIStoryboard(name: "Favorites", bundle: nil).instantiateViewController(withIdentifier: "FavoritesVC")
                                self.navigationController?.pushViewController(rootVC, animated: true)
                            }else{
                                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
                            }
                            
//                            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
//                            let controller = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
//                            controller.modalPresentationStyle = .fullScreen
//                            self.present(controller, animated: true, completion: nil)
                            
                        case 5:
                            if Helper.shared.getIsLogin() == true{
                                let rootVC = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "AddressVC")
                                self.navigationController?.pushViewController(rootVC, animated: true)
                            }else{
                                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
                            }
                            
//                            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
//                            let controller = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
//                            controller.modalPresentationStyle = .fullScreen
//                            self.present(controller, animated: true, completion: nil)
                            
                        case 6:
                            if Helper.shared.getIsLogin() == true{
                                let rootVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC")
                                self.navigationController?.pushViewController(rootVC, animated: true)
                            }else{
                                let rootVC = UIStoryboard(name: "LoginRegister", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                                self.navigationController?.pushViewController(rootVC, animated: true)
                            }
                            
                            
                            
                            
                        case 8:
                            if Helper.shared.getIsLogin() == true{
                                AlertLogout(Title: "Logout", Message: "Are you ure you want to logout?")
                            }else{
                                let phoneNumber =  "+971543721170" // you need to change this number
                                let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
                                if UIApplication.shared.canOpenURL(appURL) {
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                                    }
                                    else {
                                        UIApplication.shared.openURL(appURL)
                                    }
                                }

                            }
                            
                        case 10:
                            let phoneNumber =  "+971543721170" // you need to change this number
                            let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
                            if UIApplication.shared.canOpenURL(appURL) {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                                }
                                else {
                                    UIApplication.shared.openURL(appURL)
                                }
                            }


                        default:
                            break
                        }
        
        
        
        
        func AlertLogout(Title:String,Message:String){
            let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                Helper.shared.resetDefaults()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
//                loginManager.logOut()
//                updateButton(isLoggedIn: false)
//                updateMessage(with: nil)
                let rootVC = UIStoryboard(name: "LoginRegister", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                self.navigationController?.pushViewController(rootVC, animated: true)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            })
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let array = sideMenuList[indexPath.row]
        
        if array.cellType == .Image {
            //            return cellWidths.homeCell.rawValue
            return cellHeights.homeCell.rawValue
            
        }else if array.cellType == .SimpleCell {
            
            return cellHeights.normalCell2.rawValue
            
        }else if array.cellType == .emptyCell{
            
            return cellHeights.emptyCell.rawValue
            
        }
        else if array.cellType == .specialCell{
            return cellHeights.specialCell.rawValue
        }else {
            
            return cellHeights.separator.rawValue
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sideMenuList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let array = sideMenuList[indexPath.row]
        
        if array.cellType == .Image {
            
            let cell = ImageViewHeaderCell.cellForTableView(tableView: tableView, atIndexPath: indexPath as NSIndexPath)
            cell.selectionStyle = .none
            
            return cell
            
        }else if array.cellType == .SimpleCell {
            
            let cell = MenuListCell.cellForTableView(tableView: tableView, atIndexPath: indexPath as NSIndexPath)
            
            cell.sideTitleLabel.text = array.title
            cell.sideImageView.image = array.image
            
            return cell
            
        }
        else if array.cellType == .emptyCell{

            let cell = SeparatorCell.cellForTableView(tableView: tableView, atIndexPath: indexPath as NSIndexPath)
            cell.selectionStyle = .none
            cell.sepratorView.isHidden = true

            return cell

        }else if array.cellType == .specialCell {
            let cell = SpecialCell.cellForTableView(tableView: tableView, atIndexPath: indexPath as NSIndexPath)
            cell.Lb.text = array.title
            return cell
        }else {

            let cell = SeparatorCell.cellForTableView(tableView: tableView, atIndexPath: indexPath as NSIndexPath)
            cell.selectionStyle = .none

            return cell

        }
        
    }

}
