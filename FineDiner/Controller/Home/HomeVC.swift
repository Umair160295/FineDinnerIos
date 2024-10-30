//
//  HomeVC.swift
//  FineDiner
//
//  Created by iOS Developer on 19/12/2021.
//

import UIKit
import KRProgressHUD
import Toast_Swift
import ImagePicker
import SideMenu
import GoogleMaps
import OneSignal
import GooglePlaces
import FirebaseAnalytics


class HomeVC: BaseViewController {

    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var viewArea: UIView!
    @IBOutlet weak var viewAddAddress: UIView!
    @IBOutlet weak var viewAddress: UIView!
    

    fileprivate var areaPicker = UIPickerView() {
        didSet{
            areaPicker.delegate = self
            areaPicker.dataSource = self
        }
    }
    
    var categoriesArray = [CategoriesModel]()
    var productsArray = [ProductsModel]()
    var groupMainArray = [GroupMainM]()
    var menuArray = [MenuM]()
    var addressArray = [AddressModel]()
    var selectedDateIndex = 0
    var categoriesTitle = ""
    var address = ""
    var name = ""
    var icon = ""
    var flagGET_MENU_URL = 0
    
    var locationManager:CLLocationManager!
    var Loca:GMSMapView!
    
    
    var menuButtonLeft: UIBarButtonItem!
    var sideLeftVC : UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics(title: "Home_IOS")

        menuBtn.addTarget(self, action: #selector(onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        sideLeftVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNavigationController")
        setUpSideMenuDefaults()
        self.navigationController?.navigationBar.isHidden = true
        print(Helper.shared.getToken() ?? "")
        if Helper.shared.getIsLogin() == true{
            viewAddress.isHidden = false
            getAddress()
        }else{
            viewAddress.isHidden = true
            getGroupMainin()
        }
        upperView.viewDesign()
        setupTableView()
        setupCollectionView()
        txtArea.inputView = areaPicker
        areaPicker.delegate = self
        areaPicker.dataSource = self
        viewArea.layer.borderWidth = 0.5
        viewArea.layer.borderColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        viewAddAddress.layer.borderWidth = 0.5
        viewAddAddress.layer.borderColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(ReloadGetAddressInHome), name: NSNotification.Name(rawValue: "ReloadGetAddressInHome"), object: nil)
        StartLocation()
//        checkrate()
    }
    func checkrate(){
        guard let popup = RateorderPopup.storyboardInstance() else {return}
        self.present(popup, animated: true, completion: nil)
    }
    func Analytics(title: String) {
        FirebaseAnalytics.Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: "id-\(title)",
          AnalyticsParameterItemName: "\(title)",
          AnalyticsParameterContentType: "cont",
        ])
    }
    
    @objc func ReloadGetAddressInHome() {
        getAddress()
    }

    //    SideMenu
    @objc override func onSlideMenuButtonPressed(_ sender : UIButton){
//        if Shared.shared.flagHome == "joinPool"{
//            self.navigationController?.popViewController(animated: true)
//        }else{
            if SideMenuManager.default.leftMenuNavigationController != nil {
                self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true) {
                }
            }
//        }
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
    func homeSetup(){
        nameLbl.text = name
        titleLbl.text = categoriesTitle
        addressLbl.text = address
        iconImg.sd_setImage(with: URL(string: icon), completed: nil)
    }
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "CategoryCell")
    }
    func setupTableView() {
        tableView.register(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    func getGroupMainin(){
        NetworkManager().getGroupMain { groupMain, message, bool in
            if bool{
                self.groupMainArray = groupMain
                Helper.shared.groupMainId = groupMain[0].id as! Int
                self.collectionView.reloadData()
                self.getMenu1()
            }
        }
    }
//    func getProducts(categoryId:String){
//        KRProgressHUD.show()
//        NetworkManager().getProducts(categoryId: categoryId){ (error, isSuccess, mess,productsArray) in
//            KRProgressHUD.dismiss()
//            if isSuccess == true{
//                self.productsArray = productsArray
//                print(productsArray)
//                self.tableView.reloadData()
//            }else {
//                let style = ToastStyle()
//                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
//            }
//        }
//    }
    func getAddress(){
        self.flagGET_MENU_URL = 0
//        KRProgressHUD.show()
        NetworkManager().getAddress{ (addressArray, mess, isSuccess) in
//            KRProgressHUD.dismiss()
            if isSuccess == true{
                if mess == "empty"{
                    let obj = AddressModel(id: 0, areaId: 0, name: "", street: "", building_name: "", building_number: "", phone_number: "", long: "", lat: "", type: "Add Address")
                    self.addressArray.append(obj)
                }else{
                    self.addressArray = addressArray
                    let obj = AddressModel(id: 0, areaId: 0, name: "", street: "", building_name: "", building_number: "", phone_number: "", long: "", lat: "", type: "Add Address")
                    self.addressArray.append(obj)
                    self.txtArea.text = addressArray[0].type as? String ?? "Home"
                    Helper.shared.addressInHome = addressArray[0].type as? String ?? "Home"
                    Helper.shared.areaId = "&area_id=\(addressArray[0].areaId as! Int)"
                    Helper.shared.addressId = "\(addressArray[0].id as! Int)"
                    if self.flagGET_MENU_URL == 0{
                        self.getGroupMainin()
                    }
                    self.flagGET_MENU_URL = 1
                }
            }else {
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    func getMenu1(){
        KRProgressHUD.show()
        NetworkManager().getMenu { menu, message, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.menuArray = menu
                self.tableView.reloadData()
                self.checkVersionUpdate()
            }
        }
    }
    func checkVersionUpdate(){
        let deviceState = OneSignal.getDeviceState()
        let pleyerId = deviceState?.userId
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameter = ["firebase_token" : pleyerId ?? "0",
                         "platform" : "ios",
                         "timezone" : localTimeZoneIdentifier,
                         "app_version" : appVersion] as [String : Any]
        NetworkManager().versionUpdate(param: parameter) { message, bool in
            if bool == false{
                self.Alert1()
            }
        }
    }
    func Alert1(){
        let alert = UIAlertController(title: "Whoops", message: "There is a newer version of this app available", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Update", style: .default) { (action) in
            if let url = URL(string: "https://apps.apple.com/jo/app/fine-diner/id1621603607") {
                UIApplication.shared.open(url)
            }
        }
        alert.addAction(ok)
        self.present(alert,animated: true,completion: nil)
    }


    @IBAction func btnAddAddress(_ sender: Any) {
        Helper.shared.addressEnter = "HomeAddress"
        let storyboard = UIStoryboard(name: "Address", bundle: nil)
        if let nextVC = storyboard.instantiateViewController(withIdentifier: "AddAddressVC") as? AddAddressVC {
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
        }
    }
    @IBAction func cartTapped(_ sender: Any) {
        if Helper.shared.getIsLogin() == true{
            let rootVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC")
            self.navigationController?.pushViewController(rootVC, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "LoginRegister", bundle: nil)
            if let nextVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
            }
        }
    }
    @IBAction func menuTapped(_ sender: Any) {
//        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
    }
}
extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupMainArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell {
            cell.categoryLbl.text = groupMainArray[indexPath.row].name as? String ?? ""
            if selectedDateIndex == indexPath.item {
                cell.categoryView.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.6470588235, blue: 0.1254901961, alpha: 1)
                cell.categoryLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                cell.categoryView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.categoryLbl.textColor = #colorLiteral(red: 0.5141925812, green: 0.5142051578, blue: 0.5141984224, alpha: 1)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 130 , height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        getProducts(categoryId: "\(groupMainArray[indexPath.row].id)")
        Helper.shared.groupMainId = groupMainArray[indexPath.row].id as? Int ?? 0
        self.getMenu1()
        self.selectedDateIndex = indexPath.item
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
        self.collectionView.reloadData()
    }
}
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return menuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell{
            cell.name.text = menuArray[indexPath.row].name as? String ?? ""
            cell.productsDesc.text = menuArray[indexPath.row].description as? String ?? ""
            cell.iconImg.sd_setImage(with: URL(string: menuArray[indexPath.row].icon as?  String ?? ""), placeholderImage: UIImage(named: "Logo.png"))
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        Helper.shared.menuId = menuArray[indexPath.row].id as? Int ?? 0
        Helper.shared.menuImg = menuArray[indexPath.row].icon as? String ?? ""
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
}
extension HomeVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return addressArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        txtArea.text = addressArray[row].type as? String ?? "Home"
        Helper.shared.addressInHome = addressArray[row].type as? String ?? "Home"
        Helper.shared.areaId = "&area_id=\(addressArray[row].areaId as! Int)"
        Helper.shared.addressId = "\(addressArray[row].id as! Int)"
//        if txtArea.text == "Add Address"{
//            Helper.shared.addressEnter = "HomeAddress"
//            let storyboard = UIStoryboard(name: "Address", bundle: nil)
//            if let nextVC = storyboard.instantiateViewController(withIdentifier: "AddAddressVC") as? AddAddressVC {
//                nextVC.modalPresentationStyle = .fullScreen
//                self.present(nextVC, animated: true)
//            }
//        }
        return addressArray[row].type as? String ?? "Home"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtArea.text = addressArray[row].type as? String ?? "Home"
        Helper.shared.areaId = "&area_id=\(addressArray[row].areaId as! Int)"
        Helper.shared.addressId = "\(addressArray[row].id as! Int)"
        if txtArea.text == "Add Address"{
            Helper.shared.addressEnter = "HomeAddress"
            Helper.shared.address_type = "new"
            let storyboard = UIStoryboard(name: "Address", bundle: nil)
            if let nextVC = storyboard.instantiateViewController(withIdentifier: "AddAddressVC") as? AddAddressVC {
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
            }
        }else{
            getMenu1()
        }
    }
}


extension HomeVC: GMSMapViewDelegate, CLLocationManagerDelegate {
    func StartLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        Helper.shared.latitude = userLocation.coordinate.latitude
        Helper.shared.longitude = userLocation.coordinate.longitude
        
        
        self.locationManager.stopUpdatingHeading()
        self.locationManager.stopUpdatingLocation()
    }
}
