//
//  Helper.swift
//  FineDiner
//
//  Created by iOS Developer on 24/12/2021.
//

import Foundation
import GoogleSignIn
class Helper:NSObject {
    
    static let shared = Helper()
    private let def = UserDefaults.standard
    
    let signInConfig = GIDConfiguration(clientID: "295387888589-62pg4l7keivi20lq1il05vuritg4qdns.apps.googleusercontent.com")
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    func saveToken(auth:String)
    {
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "user_auth")
        def.synchronize()
    }
    func getToken()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_auth" ) as? String
    }
    func saveUserName(name:String){
        let def = UserDefaults.standard
        def.setValue(name, forKey: "user_name")
        def.synchronize()
    }
    func getUserName()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_name" ) as? String
    }
    func saveUserAvatar(avatar:String){
        let def = UserDefaults.standard
        def.setValue(avatar, forKey: "user_avatar")
        def.synchronize()
    }
    func getUserAvatar()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_avatar" ) as? String
    }
    func saveUserEmail(email:String){
        let def = UserDefaults.standard
        def.setValue(email, forKey: "user_email")
        def.synchronize()
    }
    func getUserEmail()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_email" ) as? String
    }
    func saveUserPhone(phone:String){
        let def = UserDefaults.standard
        def.setValue(phone, forKey: "user_phone_number")
        def.synchronize()
    }
    func getUserPhone()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_phone_number" ) as? String
    }
    func saveUserBirthDate(birth:String){
        let def = UserDefaults.standard
        def.setValue(birth, forKey: "user_birth_date")
        def.synchronize()
    }
    func getUserBirthDate()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_birth_date" ) as? String
    }
    func saveUserId(id:Int){
        let def = UserDefaults.standard
        def.setValue(id, forKey: "user_id")
        def.synchronize()
    }
    func getUserId()-> Int?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_id" ) as? Int
    }
    func saveIsLogin(IsLogin:Bool){
        let def = UserDefaults.standard
        def.setValue(IsLogin, forKey: "user_login")
        def.synchronize()
    }
    func getIsLogin()-> Bool?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_login" ) as? Bool
    }
    func saveIsAddress(IsAddress:Bool){
        let def = UserDefaults.standard
        def.setValue(IsAddress, forKey: "user_Address")
        def.synchronize()
    }
    func getIsAddress()-> Bool?{
        let def = UserDefaults.standard
        return def.object(forKey: "user_Address" ) as? Bool
    }
    func saveItemCountInPopupCart(count:Int){
        let def = UserDefaults.standard
        def.setValue(count, forKey: "ItemCountInPopupCart")
        def.synchronize()
    }
    func getItemCountInPopupCart()-> Int?{
        let def = UserDefaults.standard
        return def.object(forKey: "ItemCountInPopupCart") as? Int
    }
    
    func saveItemtTotalPriceInPopupCart(price:Double){
        let def = UserDefaults.standard
        def.setValue(price, forKey: "ItemtTotalPriceInPopupCart")
        def.synchronize()
    }
    func getItemtTotalPriceInPopupCart()-> Double?{
        let def = UserDefaults.standard
        return def.object(forKey: "ItemtTotalPriceInPopupCart") as? Double
    }
    func saveItemtTotalCurrencyInPopupCart(currency:String){
        let def = UserDefaults.standard
        def.setValue(currency, forKey: "ItemtTotalCurrencyInPopupCart")
        def.synchronize()
    }
    func getItemtTotalCurrencyInPopupCart()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "ItemtTotalCurrencyInPopupCart" ) as? String
    }
    
    
    
    
    
//    resetPasswordApi
    func savePassToken(auth:String)
    {
        let def = UserDefaults.standard
        def.setValue(auth, forKey: "pass_auth")
        def.synchronize()
    }
    func getPassToken()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "pass_auth" ) as? String
    }
    
//    Not Used yet
    func saveLat(lat:String)
    {
        let def = UserDefaults.standard
        def.setValue(lat, forKey: "lat")
        def.synchronize()
    }
    func getLat()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "lat" ) as? String
    }
    func saveLon(lon:String){
        let def = UserDefaults.standard
        def.setValue(lon, forKey: "lon")
        def.synchronize()
    }
    func getLon()-> String?{
        let def = UserDefaults.standard
        return def.object(forKey: "lon" ) as? String
    }
//    Not Used yet

    
    var verifyToken = ""
    var verifyType = ""
    
    
    var itemCountInPopupCart = 0
    var itemtTotalPriceInPopupCart = 0.0
    var itemtTotalCurrencyInPopupCart = ""
    
    
    var cityAddId = 0
    var areaAddId = 0
    var areaId = ""
    var addressInHome = ""
    var addressEnter = ""
    
    var groupMainId = 0
    
    var bannerArray : NSArray = []
    var attributArray : NSArray = []
    var itemMaxMinArray : NSArray = []
    var itemMaxArray : NSArray = []
    var itemSectionArray : NSArray = []
    
    var productName = ""
    var productDes = ""
    var productPrice = ""
    var productImage = ""
    var productId = 0
    var productType = ""
    
    var menuName = ""
    var menuDescription = ""
    var menuImg = ""
    var menuId = 0
    var menuRate = 0.0
    
    var orderId = 0
    
//    postOrder
    var addressId = ""
    var payment = ""
    var dateOrder = ""
    var timeOrder = ""
    
    var start_time_Order = ""
    var end_time_Order = ""
    
    var type_time = ""
    var promoCode = ""
    var note = ""
    
    var OTP = ""
    var provider_token = ""
    var provider_id = ""
    var provider = ""
    
    var latitude = 0.0
    var longitude = 0.0
    
    var countProductOfYourOrder = 0
    var orderPrice = 0.0
    
    var CardID = 0
    
    var Address_Id = 0
    var address_type = ""
    
    var city_id = 0
    var area_id = 0
    var address_line = ""
    var bulliding_name = ""
    var Apartment_number =  ""
    var address_name = ""
    
    var order_id = 0
    
}
