//
//  GroupVC.swift
//  FineDiner
//
//  Created by iOS Developer on 20/12/2021.
//

import UIKit
import KRProgressHUD
import Toast_Swift
import ImagePicker
import Adjust

class GroupDetailsVC: UIViewController {


    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productCountlbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var tableViewBanner: UITableView!
    @IBOutlet weak var viewCart: UIView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var imgMenu: UIImageView!
    
    
    
    var selectedDateIndex = 0
    var productId = ""
    var menuId = 0
    var flagFavorite = true
    
    var productsArray = [ProductsModel]()
    var itemsArray = [ProductsDetailsModel]()
    var menuShowCategoryArray = [MenuShowCategoryM]()
    var bannerArray = [BannerM]()
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewCart.isHidden = true
        tableViewBanner.viewDesign()
//        self.imgMenu.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.imgMenu.layer.cornerRadius = 30
        self.imgMenu.layer.masksToBounds = true
        setupTableView()
        setupCollectionView()
        getMenuShow()
    }
    override func viewDidAppear(_ animated: Bool) {
        if Helper.shared.getIsLogin() == true{
            getCart()
        }
    }
    //MARK:- function
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "CategoryCell")
    }
    func setupTableView() {
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    func SetupBannerTable() {
        tableViewBanner.dataSource = self
        tableViewBanner.delegate = self
        tableViewBanner.register(UINib(nibName: "BannerCell", bundle: nil), forCellReuseIdentifier: "BannerCell")
        self.tableViewBanner.reloadData()
    }
    func getCart(){
        NetworkManager().getCart { cart, message, bool, delivery_price, item_price, total_price, check   in
            if bool{
                if Helper.shared.getItemCountInPopupCart() == 0{
                    self.viewCart.isHidden = true
                }else{
                    self.viewCart.isHidden = false
                    self.productCountlbl.text = "\(Helper.shared.getItemCountInPopupCart() ?? 0) ITEM"
                    self.priceLbl.text = "\(Helper.shared.getItemtTotalCurrencyInPopupCart() ?? "") \(Helper.shared.getItemtTotalPriceInPopupCart() ?? 0.0)"
                }
            }
        }
    }
    func getMenuShow(){
        NetworkManager().getMenuShow { menu, banner, message, bool, description, icon, id, is_favorite, name, rate  in
            if bool{
                self.menuShowCategoryArray = menu
                self.bannerArray = banner
                self.SetupBannerTable()
                Helper.shared.bannerArray = banner as NSArray
                self.getProducts(categoryId: "\(menu[0].id as! Int)")
                self.collectionView.reloadData()
                self.productDesc.text = description
                self.name.text = name
                HomeVC().Analytics(title: "\(name)_IOS")
                let event = ADJEvent(eventToken: "jzgvhp")
                Adjust.trackEvent(event)
                self.rateLbl.text = "\(rate)"
                self.menuId = id
                print(is_favorite)
                self.flagFavorite = is_favorite
                if is_favorite == true{
                    self.btnFavorite.setImage(UIImage(named: "Fav"), for: .normal)
                }else{
                    self.btnFavorite.setImage(UIImage(named: "Favorites"), for: .normal)
                }
                Helper.shared.menuRate = rate
                Helper.shared.menuId = id
                Helper.shared.menuImg = icon
                Helper.shared.menuName = name
                Helper.shared.menuDescription = description
                


                if banner.count == 0{
                    self.tableViewBanner.isHidden = true
                    let img = icon
                    if img == ""{
                        self.imgMenu.image = UIImage(named: "Image")
                    }else{
                        self.imgMenu.sd_setImage(with: URL(string: img), completed: nil)
                    }
                }else{
                    self.imgMenu.isHidden = true
                    self.tableViewBanner.isHidden = false
                }
                
                
                
            }
        }
    }
    func getProducts(categoryId:String){
        KRProgressHUD.show()
        NetworkManager().getProducts(categoryId: categoryId){ (error, isSuccess, mess,productsArray) in
            KRProgressHUD.dismiss()
            if isSuccess == true{
                self.productsArray = productsArray
                self.tableView.reloadData()
            }else {
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    //MARK:- button
    @IBAction func backTapped(_ sender: Any) {
//        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {return}
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func viewCart(_ sender: Any) {
        if Helper.shared.getIsLogin() == true{
            let rootVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC")
            self.navigationController?.pushViewController(rootVC, animated: true)
        }else{
        let message = "Please, login"
        let style = ToastStyle()
         self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
        }
        

    }
    @IBAction func allReviewsTapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewsVC") as? ReviewsVC else {return}
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    @IBAction func btnFavorite(_ sender: Any) {
        if Helper.shared.getIsLogin() == true{
            KRProgressHUD.show()
            NetworkManager().postFavorite(favoriteId: "\(menuId)") { error, isSucces, mess in
                KRProgressHUD.dismiss()
                if isSucces == true{
                    if self.flagFavorite == false{
                        self.flagFavorite = true
                        self.btnFavorite.setImage(UIImage(named: "Fav"), for: .normal)
                    }else{
                        self.flagFavorite = false
                        self.btnFavorite.setImage(UIImage(named: "Favorites"), for: .normal)
                    }
                    let style = ToastStyle()
                    self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
                }else{
                    let style = ToastStyle()
                    self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
                }
            }
        }else{
            let message = "Please, login"
            let style = ToastStyle()
             self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
        }
    }
    
}
    //MARK:- collectionView delegate
extension GroupDetailsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuShowCategoryArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.setData(data: menuShowCategoryArray[indexPath.row])
        if selectedDateIndex == indexPath.item {
            cell.categoryView.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.6470588235, blue: 0.1254901961, alpha: 1)
            cell.categoryLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            cell.categoryView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.categoryLbl.textColor = #colorLiteral(red: 0.5141925812, green: 0.5142051578, blue: 0.5141984224, alpha: 1)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        let name = menuShowCategoryArray[indexPath.row].name as? String ?? ""
        print(Double(name.count))
        print(Double(name.count) * 8.5)
        if name.count < 12{
            return CGSize(width: 90, height: 50)
        }else if name.count < 16{
            return CGSize(width: 130, height: 50)
        }else if name.count < 20{
            return CGSize(width: 170, height: 50)
        }
//        else if name.count < 16{
//            return CGSize(width: 130, height: 50)
//        }
        return CGSize(width: Double(name.count) * 8.5 , height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          getProducts(categoryId: "\(menuShowCategoryArray[indexPath.item].id as! Int)")
        self.selectedDateIndex = indexPath.item
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
        self.collectionView.reloadData()
    }
}
//MARK:- tableView delegate
extension GroupDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tableViewBanner{
            return 1
        }
        return productsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView == tableViewBanner{
            let cell = tableViewBanner.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as? BannerCell
            cell?.Vc = self
            return cell!
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell{
            cell.nameLbl.text = productsArray[indexPath.row].name
            cell.descLbl.text = productsArray[indexPath.row].productDescription
            cell.iconImg.sd_setImage(with: URL(string: productsArray[indexPath.row].icon), completed: nil)
            cell.priceLbl.text = productsArray[indexPath.row].formatted
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if tableView == tableViewBanner{
            return 227
        }
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView == tableViewBanner{
            
        }else{
            Helper.shared.productId = productsArray[indexPath.row].id
            Helper.shared.productName = productsArray[indexPath.row].name
            print(productsArray[indexPath.row].description)
            Helper.shared.productDes = productsArray[indexPath.row].productDescription
            Helper.shared.productPrice = productsArray[indexPath.row].formatted
            Helper.shared.productImage = productsArray[indexPath.row].icon
            if productsArray[indexPath.row].type == "product"{
                Helper.shared.productType = "product"
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                if let nextVC = storyboard.instantiateViewController(withIdentifier: "ProductRadioVC") as? ProductRadioVC {
//                    nextVC.modalPresentationStyle = .fullScreen
//                    self.present(nextVC, animated: true)
//                }
                
                let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductRadioVC")
                self.navigationController?.pushViewController(rootVC, animated: true)
            }else if productsArray[indexPath.row].type == "variant_product"{
                Helper.shared.productType = "variant_product"
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                if let nextVC = storyboard.instantiateViewController(withIdentifier: "ProductRadioVC") as? ProductRadioVC {
//                    nextVC.modalPresentationStyle = .fullScreen
//                    self.present(nextVC, animated: true)
//                }
                
                let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductRadioVC")
                self.navigationController?.pushViewController(rootVC, animated: true)
            }else if productsArray[indexPath.row].type == "modifier"{
                guard let popup = AddCartPopup.storyboardInstance() else {return}
                self.present(popup, animated: true, completion: nil)
            }
          }
        }
}
