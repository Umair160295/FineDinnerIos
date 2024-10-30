//
//  YourOrdersVC.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import KRProgressHUD
import Toast_Swift
import SideMenu

class YourOrdersVC: BaseViewController {
    
    var dataList = [OrderM]()
    var menuButtonLeft: UIBarButtonItem!
    var sideLeftVC : UIViewController!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        setupTableView()
        getOrders()
        menuBtn.addTarget(self, action: #selector(onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        sideLeftVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNavigationController")
        setUpSideMenuDefaults()
    }
    
    @objc func refreshData() {
        getOrders()
        refreshControl.endRefreshing()
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
    func getOrders()  {
        KRProgressHUD.show()
        NetworkManager().getOrder { order, message, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.dataList = order
                self.tableView.reloadData()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 1.5, position: .bottom, style: style)
            }
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "OrdersCell", bundle: nil), forCellReuseIdentifier: "OrdersCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    @IBAction func menuTapped(_ sender: Any) {
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
    }
}
extension YourOrdersVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell", for: indexPath) as? OrdersCell{
            cell.setData(data: dataList[indexPath.row])
            if dataList[indexPath.row].status as? String ?? "" == "cancelled" || dataList[indexPath.row].status as? String ?? "" == "falied" || dataList[indexPath.row].status as? String ?? "" == "refunded" {
                cell.BtnStatsOrder.tintColor = .red
            }else if dataList[indexPath.row].status as? String ?? "" == "processing"{
                cell.BtnStatsOrder.tintColor = .green
            }else if dataList[indexPath.row].status as? String ?? "" == "preparing"{
                cell.BtnStatsOrder.tintColor = .blue
            }else if dataList[indexPath.row].status as? String ?? "" == "delivered"{
                cell.BtnStatsOrder.tintColor = .black
            }
            else{
                cell.BtnStatsOrder.tintColor = .green
            }
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        Helper.shared.orderId = dataList[indexPath.row].id as? Int ?? 0
        Helper.shared.countProductOfYourOrder = dataList[indexPath.row].count_items as? Int ?? 0
//        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsVC else {return}
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: true)
        
        let rootVC = UIStoryboard(name: "Your Orders", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailsVC")
        self.navigationController?.pushViewController(rootVC, animated: true)
    }
}
