//
//  FavoritesVC.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import KRProgressHUD
import Toast_Swift
import SideMenu

class FavoritesVC: BaseViewController {

    var dataList = [FavoritesM]()
    var menuButtonLeft: UIBarButtonItem!
    var sideLeftVC : UIViewController!
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getFavorites()
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
        tableView.register(UINib(nibName: "FavoritesCell", bundle: nil), forCellReuseIdentifier: "FavoritesCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getFavorites(){
        KRProgressHUD.show()
        NetworkManager().getFavorite { favorite, message, bool in
            KRProgressHUD.dismiss()
            if bool{
                if favorite.count == 0{
                    self.dataList = []
                }else{
                    self.dataList = favorite
                }
                self.tableView.reloadData()
            }else{
                self.dataList = []
                self.tableView.reloadData()
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
    }
}
extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as? FavoritesCell{
            cell.setData(data: dataList[indexPath.row])
            cell.btnFavorite.tag = indexPath.row
            cell.btnFavorite.addTarget(self, action: #selector(deleteFavorites(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 250
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Helper.shared.menuId = dataList[indexPath.row].id as? Int ?? 0
        Helper.shared.menuImg = dataList[indexPath.row].icon as? String ?? ""
        if Helper.shared.getIsLogin() == true{
            if Helper.shared.areaId == "" {
                let style = ToastStyle()
                self.view.makeToast("Please, select address", duration: 4.0, position: .bottom, style: style)
            }else{
                let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GroupDetailsVC")
                self.navigationController?.pushViewController(rootVC, animated: true)
            }
        }else{
            let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GroupDetailsVC")
            self.navigationController?.pushViewController(rootVC, animated: true)
        }

    }
    
    @objc func deleteFavorites(_ sender: UIStepper){
        let favorite = dataList[sender.tag]
        KRProgressHUD.show()
        NetworkManager().postFavorite(favoriteId: "\(favorite.id as? Int ?? 0)") { error, isSucces, mess in
            KRProgressHUD.dismiss()
            if isSucces == true{
                self.getFavorites()
            }else{
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
    }

    

}

