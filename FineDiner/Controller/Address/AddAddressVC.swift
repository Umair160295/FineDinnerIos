//
//  AddAddressVC.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import FlagPhoneNumber
import CoreLocation
import GoogleMaps
import GooglePlaces
import KRProgressHUD
import Toast_Swift


class AddAddressVC: UIViewController {

    @IBOutlet weak var phoneTxt: FPNTextField!
    @IBOutlet weak var buildingNoTxt: UITextField!
    @IBOutlet weak var areaTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var streetTxt: UITextField!
    @IBOutlet weak var buildingTxt: UITextField!
    @IBOutlet weak var floorTxt: UITextField!
    @IBOutlet weak var apartmentNumTxt: UITextField!
    @IBOutlet weak var addressNameTxt: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewArea: UIView!
    @IBOutlet weak var viewCity: UIView!
    
    @IBOutlet weak var officeBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    //MARK:- Variables
    var type = ""
    var id = 0
    var deleteId = ""
    var cityId = 0
    var arearId = 0
    var flagArearOpen = 0
    var model:AddressModel?
    var areaArray = [AreaM]()
    var cityArray = [CityM]()
    let markerStart = GMSMarker()
    
    var locationManager:CLLocationManager!
    var isMapMove:String! = "YES"
    var Lat = Helper.shared.latitude
    var Long = Helper.shared.longitude
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Helper.shared.getIsAddress() == true{
            btnBack.isHidden = false
        }else{
            btnBack.isHidden = true
        }
        contactNoSetup()
        if Helper.shared.address_type == "edit"{
            print(Helper.shared.Address_Id)
            print(Helper.shared.area_id)
            self.buildingNoTxt.text = Helper.shared.address_line
            self.buildingTxt.text = Helper.shared.bulliding_name
            self.apartmentNumTxt.text = Helper.shared.Apartment_number
            self.addressNameTxt.text = Helper.shared.address_name
            self.arearId = Helper.shared.area_id
            areaTxt.isEnabled = true
            self.getCity()
        }else{
            getCity()
        }
        
        cityTxt.inputView = cityPicker
        cityPicker.delegate = self
        cityPicker.dataSource = self
        areaTxt.inputView = areaPicker
        areaPicker.delegate = self
        areaPicker.dataSource = self
        
        areaTxt.isEnabled = true
        viewArea.layer.borderWidth = 0.5
        viewArea.layer.borderColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        viewArea.layer.cornerRadius = 5
        viewCity.layer.borderWidth = 0.5
        viewCity.layer.borderColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        viewCity.layer.cornerRadius = 5
        StartLocation()
        mapView.delegate = self
        mapPin()
        
    }
    
    func mapPin(){
        mapView.clear()
        mapView.camera = GMSCameraPosition.camera(withLatitude:Lat, longitude:Long , zoom:17)
        let circleView1 = UIImageView(frame: CGRect(x: mapView.frame.width/2.2, y: mapView.frame.height/2.2, width:21, height:30))
        circleView1.image = UIImage(named:"pin2")!
        mapView.addSubview(circleView1)
        mapView.bringSubviewToFront(circleView1)
    }
    
    func StartLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }

    }

    
    //    PickerView
    fileprivate var cityPicker = UIPickerView() {
        didSet{
            cityPicker.delegate = self
            cityPicker.dataSource = self
        }
    }
    
    fileprivate var areaPicker = UIPickerView() {
        didSet{
            areaPicker.delegate = self
            areaPicker.dataSource = self
        }
    }
    
    //MARK:- Functions
    
    func getArea(){
        NetworkManager().getAreaCity { area, message, bool in
            if bool{
                var indexPath = 0
                self.areaArray = area
                print(Helper.shared.area_id)
                print(self.arearId)
                if Helper.shared.address_type == "edit"{
                    for i in area{
                        if i.id as! Int == Helper.shared.area_id{
                            self.areaTxt.text = self.areaArray[indexPath].name as? String ?? ""
                            Helper.shared.areaAddId = self.areaArray[indexPath].id as? Int ?? 0
                            break
                        }
                        
                    }
                    indexPath += 1
                }else{
                    self.areaTxt.text = self.areaArray[0].name as? String ?? ""
                    Helper.shared.areaAddId = self.areaArray[0].id as? Int ?? 0
                }
                
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    func getCity(){
        NetworkManager().getCity { city, message, bool in
            if bool{
                if Helper.shared.address_type == "edit"{
                    self.getArea()
                }
                self.cityArray = city
                self.cityTxt.text = city[0].name as? String ?? ""
                Helper.shared.cityAddId = city[0].id as? Int ?? 0
                self.getArea()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }

    func contactNoSetup(){
        phoneTxt.delegate = self
        phoneTxt.hasPhoneNumberExample = false
        phoneTxt.setCountries(including: [.JO])
        phoneTxt.textColor = UIColor.black
//        phoneTxt.placeholder = ""
    }
    private func validateViews() -> Bool {
        let valid = true
        if let name = buildingNoTxt.text {
            if name.count == 0 {
                let style = ToastStyle()
                self.view.makeToast("Address Line 1 Required", duration: 4.0, position: .bottom, style: style)
                return false
            }
        }
        if let City = cityTxt.text {
            if City.count == 0 {
                let style = ToastStyle()
                self.view.makeToast("City Required", duration: 4.0, position: .bottom, style: style)
                return false
            }
        }
        if let Area = areaTxt.text {
            if Area.count == 0 {
                let style = ToastStyle()
                self.view.makeToast("Area Required", duration: 4.0, position: .bottom, style: style)
                return false
            }
        }
        if let Building = buildingTxt.text {
            if Building.count == 0 {
                let style = ToastStyle()
                self.view.makeToast("Building Name Required", duration: 4.0, position: .bottom, style: style)
                return false
            }
        }
        if let Apartment = apartmentNumTxt.text {
            if Apartment.count == 0 {
                let style = ToastStyle()
                self.view.makeToast("Apartment Number Required", duration: 4.0, position: .bottom, style: style)
                return false
            }
        }
            if let AddressName = addressNameTxt.text {
                if AddressName.count == 0 {
                let style = ToastStyle()
                self.view.makeToast("Address name Required", duration: 4.0, position: .bottom, style: style)
                return false
                }
            }
    
        return valid
    }

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func jumbToPopup() {
        guard let popup = AddPhoneNumberPopup.storyboardInstance() else {return}
        self.present(popup, animated: true, completion: nil)
    }
    func edit_address(){
        let param = ["city_id":Helper.shared.cityAddId,
                     "area_id":Helper.shared.areaAddId,
                     "address_type_id":self.buildingNoTxt.text!,
                     "street":"",
                     "building_name":self.buildingTxt.text!,
                     "building_number":self.apartmentNumTxt.text!,
                     "phone_number":Helper.shared.getUserPhone() ?? "",
                     "long":Helper.shared.longitude,
                     "lat":Helper.shared.latitude] as [String:Any]
        KRProgressHUD.show()
        NetworkManager().Edit_address(param: param) { mess, bool in
            KRProgressHUD.dismiss()
            if bool{
                let style = ToastStyle()
                self.view.makeToast("Address updated successfully", duration: 4.0, position: .bottom, style: style)
            }else{
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
            
        }
    }
    @IBAction func saveTapped(_ sender: Any) {
        if validateViews(){
        let phone = Helper.shared.getUserPhone() ?? ""
        print(phone)
        if phone == ""{
            jumbToPopup()
        }else{
            KRProgressHUD.show()
            let lat:String = "\(Helper.shared.latitude)"
            let lon:String =  "\(Helper.shared.longitude)"
            NetworkManager().addAddress(area: Helper.shared.areaAddId,
                                        city: Helper.shared.cityAddId,
                                        street: buildingNoTxt.text!,
                                        building_name: buildingTxt.text!,
                                        building_number: apartmentNumTxt.text!,
                                        phone_number: phone,
                                        long: lon,
                                        lat: lat,
                                        type: "1",
                                        name: addressNameTxt.text!){ (error, isSuccess, mess) in
                KRProgressHUD.dismiss()
                if isSuccess == true{
                    if Helper.shared.addressEnter == "CartAddress"{
                        self.dismiss(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadGetAddress"), object: nil)
                    }else if Helper.shared.addressEnter == "HomeAddress"{
                        self.dismiss(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadGetAddressInHome"), object: nil)
                    }else if Helper.shared.addressEnter == "MainAddress"{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let nextVC = storyboard.instantiateViewController(withIdentifier: "NavHomeVC") as? NavHomeVC {
                            nextVC.modalPresentationStyle = .fullScreen
                            self.present(nextVC, animated: true)
                        }
                    }else if Helper.shared.addressEnter == "FirstAddress"{
                        Helper.shared.saveIsAddress(IsAddress: true)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let nextVC = storyboard.instantiateViewController(withIdentifier: "NavHomeVC") as? NavHomeVC {
                            nextVC.modalPresentationStyle = .fullScreen
                            self.present(nextVC, animated: true)
                        }
                    }
                }else{
                    let style = ToastStyle()
                    self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
                }
            }
        }
      }

    }
    
    @IBAction func homeTapped(_ sender: Any) {
        type = "1"
        homeBtn.setImage(UIImage(named: "check"), for: .normal)
        officeBtn.setImage(UIImage(named: "un-check"), for: .normal)
    }
    @IBAction func officeTapped(_ sender: Any) {
        type = "2"
        officeBtn.setImage(UIImage(named: "check"), for: .normal)
        homeBtn.setImage(UIImage(named: "un-check"), for: .normal)
    }
    @IBAction func deleteTapped(_ sender: Any) {
        print(deleteId)
        KRProgressHUD.show()
        NetworkManager().deleteAddress(addressId: deleteId){ (error, isSuccess, mess) in
            KRProgressHUD.dismiss()
            if isSuccess == true{
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC else {return}
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
            }else {
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
}
extension AddAddressVC: FPNTextFieldDelegate {
    func fpnDisplayCountryList() {
        
    }
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {

    }
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
//        self.isValid = isValid
    }
}
//MARK:- Extentions
extension AddAddressVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cityPicker{
            return cityArray.count
        }
            return areaArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPicker{
            cityTxt.text = cityArray[row].name as! String
            Helper.shared.cityAddId = cityArray[row].id as! Int
           
            areaTxt.isEnabled = true
            if flagArearOpen == 0{
                flagArearOpen = 1
                getArea()
            }
            return cityArray[row].name as! String
        }
        
        areaTxt.text = areaArray[row].name as! String
        Helper.shared.areaAddId = areaArray[row].id as! Int
        return areaArray[row].name as! String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cityPicker{
            cityTxt.text = cityArray[row].name as! String
            Helper.shared.cityAddId = cityArray[row].id as! Int
            areaTxt.isEnabled = true
            getArea()
        }else{
        areaTxt.text = areaArray[row].name as! String
        Helper.shared.areaAddId = areaArray[row].id as! Int
        }

    }
    
}



extension AddAddressVC: GMSMapViewDelegate,CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
//        Lat = userLocation.coordinate.latitude
//        Long = userLocation.coordinate.longitude
//        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        let position = CLLocationCoordinate2D(latitude:userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude)
        mapView.camera = GMSCameraPosition.camera(withLatitude:userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude , zoom:16)
        markerStart.position = position
        markerStart.icon = UIImage(named: "Pin")
//        self.markerStart.map = mapView
        self.locationManager.stopUpdatingHeading()
        self.locationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//        let loc: CLLocation = CLLocation(latitude: Helper.shared.latitude, longitude:Helper.shared.longitude)
//        Helper.shared.latitude = mapView.camera.target.latitude
//        Helper.shared.longitude = mapView.camera.target.longitude
//        let locationEnd = CLLocationCoordinate2D(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude)
//        markerStart.position = locationEnd
//        markerStart.icon = UIImage(named: "Pin")
//        markerStart.map = mapView
        let loc: CLLocation = CLLocation(latitude: Helper.shared.latitude, longitude: Helper.shared.longitude)
        if(isMapMove == "YES"){
            let ceo: CLGeocoder = CLGeocoder()
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }else{
                        let pm = placemarks! as [CLPlacemark]
                        
                        if pm.count > 0 {
                            Helper.shared.latitude = mapView.camera.target.latitude
                            Helper.shared.longitude = mapView.camera.target.longitude
                            
//                            mapView.clear()
                            let position = CLLocationCoordinate2D(latitude:mapView.camera.target.latitude, longitude:mapView.camera.target.longitude)
                            mapView.camera = GMSCameraPosition.camera(withLatitude:mapView.camera.target.latitude, longitude:mapView.camera.target.longitude , zoom:16)
                            self.markerStart.position = position
                            self.markerStart.icon = UIImage(named: "Pin")
//                            self.markerStart.map = mapView
                            print(Helper.shared.latitude)
                            print(Helper.shared.longitude)
                        }
                    }
            })
        }else{
            self.isMapMove = "YES"
        }
    }
    
}
