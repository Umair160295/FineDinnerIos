//
//  LocationVC.swift
//  Finediner
//
//  Created by Hala Zyod on 1/11/21.
//  Copyright © 2021 QTech Networks. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import KRProgressHUD
import Toast_Swift
class LocationVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pickLocationBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:- Variables
    let locationManager = CLLocationManager()
    let regionRadius: Double = 10000
    var previousLocation: CLLocation?
    var location:CLLocationCoordinate2D!

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.barTintColor = UIColor.white
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        mapView.delegate = self
    }
    
    //MARK:- Functions
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //MARK:- IBAction
    @IBAction func pickLocationTapped(_ sender: Any) {
        location = mapView.centerCoordinate
        guard let latitud = location?.latitude, let longitud = location?.longitude else {return}
        let lat:String = "30.585200"//"\(latitud)"
        let lon:String =  "36.238400"//"\(longitud)
        Helper.shared.saveLat(lat: lat)
        Helper.shared.saveLon(lon: lon)
//        KRProgressHUD.show()
//        NetworkManager().getMenu(lat: lat, long: lon){ (error, isSuccess, mess,menuArray) in
//            KRProgressHUD.dismiss()
//            if isSuccess == true{
//                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {return}
//                for item in menuArray{
//                    nextVC.name = item.name
//                    nextVC.categoriesTitle = item.title
//                    nextVC.address = item.address
//                    nextVC.icon = item.icon
//                    print(item.categories)
//                    nextVC.categoriesArray = item.categories
//                }
//                nextVC.menuArray = menuArray
//                nextVC.modalPresentationStyle = .fullScreen
//                self.present(nextVC, animated: true)
//            }else {
//                let style = ToastStyle()
//                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
//            }
//        }
    }
}
//MARK:- Extentions
extension LocationVC: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            manager.stopUpdatingLocation()
        }
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print(locValue.latitude)
        print(locValue.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}
