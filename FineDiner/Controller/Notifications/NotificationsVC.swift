//
//  NotificationsVC.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import KRProgressHUD
import Toast_Swift
import SideMenu

class NotificationsVC: BaseViewController {
    
    var dataList = [NotificationM]()
    var menuButtonLeft: UIBarButtonItem!
    var sideLeftVC : UIViewController!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getNotifications()
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
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getNotifications() {
        KRProgressHUD.show()
        NetworkManager().getNotification { notification, message, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.dataList = notification
                self.tableView.reloadData()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 1.5, position: .bottom, style: style)
            }
        }
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
    }
}
extension NotificationsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell{
            cell.setData(data: dataList[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 200
    }
    

}
