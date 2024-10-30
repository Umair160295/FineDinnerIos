//
//  NetworkManager.swift
//  FineDiner
//
//  Created by iOS Developer on 24/12/2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import ImagePicker
import OneSignal

class NetworkManager{
    let Headers : HTTPHeaders = ["Accept" : "application/json",
                                 "Content-Type": "application/json"]
    let HeadersAuth: HTTPHeaders = ["Accept" : "application/json",
                                    "Authorization": "Bearer\(Helper.shared.getToken() ?? "")"]
    
    //MARK:- Login
    func registerRequest(name:String, email :String, password:String ,password_confirmation:String ,completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?) -> Void){
        let deviceState = OneSignal.getDeviceState()
        let pleyerId = deviceState?.userId
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters = [
            "name" : name,
            "email" : email,
            "token" : Helper.shared.verifyToken,
            "password" : password,
            "password_confirmation" : password_confirmation,
            "firebase_token" : pleyerId ?? "",
            "platform" : "ios",
            "timezone" : localTimeZoneIdentifier,
            "app_version" : appVersion ?? ""] as [String : Any]
        
        AF.request(REGISTER_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Headers).responseJSON{ (response) in
            
            print(REGISTER_URL)
            print("SignUp Parameters")
            print(parameters)
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let data = json["data"].dictionary {
                    if let token = data["token"]?.string,let user = data["user"]?.dictionary {
                        Helper.shared.saveToken(auth: token)
                        let avatar = user["avatar"]?.string ?? ""
                        Helper.shared.saveUserAvatar(avatar: avatar)
                        let email = user["email"]?.string ?? ""
                        Helper.shared.saveUserEmail(email: email)
                        let phone_number = user["phone_number"]?.string ?? ""
                        Helper.shared.saveUserPhone(phone: phone_number)
                        let birth_date = user["birth_date"]?.string ?? ""
                        Helper.shared.saveUserBirthDate(birth: birth_date)
                        let name = user["name"]?.string ?? ""
                        Helper.shared.saveUserName(name: name)
                        let id = user["id"]?.int ?? 0
                        Helper.shared.saveUserId(id: id)

                        completion(nil,true,mess)
                        return
                    }else{
                        completion(nil,false,mess)
                        return
                    }
                }
                completion(nil,false,mess)
                return
            }
        }
    }
    func verifyApi(param:[String:Any],completion: @escaping(_ value:String,_ value:Bool) -> Void){
        AF.request(VERIFY_URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: Headers).responseJSON{ (response) in
            print(param)
            print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            
            
            if statusCode == 200 || statusCode == 422 {
                switch response.result
                {
                case .failure(let error):
                    completion("\(error)", false)
                    print(error)
                    return
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! NSDictionary
                        let token = data["token"] as? String ?? ""
                        Helper.shared.verifyToken = token
                        completion("", true)
                    }else{
                        let message = dic["message"] as! NSString
                        completion(message as String, false)
                    }
                }
            }else{
                completion("Something wrong!" as String, false)
            }
        }
    }
    func checkCodeApi(param:[String:Any],completion: @escaping(_ value:String,_ value:Bool) -> Void){
        AF.request(CHECK_CODE_URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response) in
            print(response)
            switch response.result
            {
            case .failure(let error):
                completion("\(error)", false)
                print(error)
                return
            case .success(let value):
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    completion("", true)
                }else{
                    let message = dic["message"] as! NSString
                    completion(message as String, false)
                }
            }
        }
    }
    func updatePhoneApi(param:[String:Any],completion: @escaping(_ value:String,_ value:Bool) -> Void){
        AF.request(UPDATE_PHONE_URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response) in
            print(response)
            switch response.result
            {
            case .failure(let error):
                completion("\(error)", false)
                print(error)
                return
            case .success(let value):
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    completion("", true)
                }else{
                    let message = dic["message"] as! NSString
                    completion(message as String, false)
                }
            }
        }
    }
    func loginRequest(phone_number:String, password:String, completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?) -> Void){
        
        let parameters = [
            
            "phone_number" : phone_number,
            "password" : password,
            "firebase_token" : "token",
            "platform" : "ios",
            "timezone" : "Asia/Amman",
            "app_version" : "V1.0"
        ] as [String : Any]
        print(parameters)
        print(HeadersAuth)
        print("dfhjsn")
        AF.request(LOGIN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            print(LOGIN_URL)
            print(response)
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let data = json["data"].dictionary {
                    if let token = data["token"]?.string,let user = data["user"]?.dictionary {
                        Helper.shared.saveToken(auth: token)
                        let avatar = user["avatar"]?.string ?? ""
                        Helper.shared.saveUserAvatar(avatar: avatar)
                        let email = user["email"]?.string ?? ""
                        Helper.shared.saveUserEmail(email: email)
                        let phone_number = user["phone_number"]?.string ?? ""
                        Helper.shared.saveUserPhone(phone: phone_number)
                        let birth_date = user["birth_date"]?.string ?? ""
                        Helper.shared.saveUserBirthDate(birth: birth_date)
                        let name = user["name"]?.string ?? ""
                        Helper.shared.saveUserName(name: name)
                        let id = user["id"]?.int ?? 0
                        Helper.shared.saveUserId(id: id)
                        completion(nil,true,mess)
                        return
                    }else{
                        completion(nil,false,mess)
                        return
                    }
                }
                completion(nil,false,mess)
                return
            }
        }
    }
    func loginSocialRequest(param:[String:Any],completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?) -> Void){
        AF.request(LOGIN_SOCIAL_URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            print(LOGIN_SOCIAL_URL)
            print(param)
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let data = json["data"].dictionary {
                    if let token = data["token"]?.string,let user = data["user"]?.dictionary {
                        Helper.shared.saveToken(auth: token)
                        let avatar = user["avatar"]?.string ?? ""
                        Helper.shared.saveUserAvatar(avatar: avatar)
                        let email = user["email"]?.string ?? ""
                        Helper.shared.saveUserEmail(email: email)
                        let phone_number = user["phone_number"]?.string ?? ""
                        Helper.shared.saveUserPhone(phone: phone_number)
                        let birth_date = user["birth_date"]?.string ?? ""
                        Helper.shared.saveUserBirthDate(birth: birth_date)
                        let name = user["name"]?.string ?? ""
                        Helper.shared.saveUserName(name: name)
                        let id = user["id"]?.int ?? 0
                        Helper.shared.saveUserId(id: id)
                        completion(nil,true,mess)
                        return
                    }else{
                        completion(nil,false,mess)
                        return
                    }
                }
                completion(nil,false,mess)
                return
            }
        }
    }
    func getProfile(completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?,_ name:String?,_ phone_number:String?,_ email:String?,_ avatar:String?,_ birth_date:String?) -> Void){
        
        print(Helper.shared.getToken())
        AF.request(GET_PROFILE_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            
            print(REGISTER_URL)
            
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil,nil,nil,nil,nil,nil)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let data = json["data"].dictionary {
                    let name = data["name"]?.string ?? ""
                    let phone_number = data["phone_number"]?.string ?? ""
                    let email = data["email"]?.string ?? ""
                    let avatar = data["avatar"]?.string ?? ""
                    let birth_date = data["birth_date"]?.string ?? ""
                    
                    completion(nil,true,mess,name,phone_number,email,avatar,birth_date)
                    return
                    
                }
                completion(nil,false,mess,nil,nil,nil,nil,nil)
                return
            }
        }
    }
    
    func updateProfile(name:String, avatar:UIImage?, birth_date:String, completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?) -> Void){
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(avatar!.jpegData(compressionQuality: 0.5)!, withName: "avatar" , fileName: "file.jpeg", mimeType: "image/jpeg")
                multipartFormData.append(name.data(using: String.Encoding.utf8)!, withName: "name")
                multipartFormData.append(birth_date.data(using: String.Encoding.utf8)!, withName: "birth_date")
            },
            to: UPDATE_PROFILE_URL, method: .post , headers: HeadersAuth)
            .response { response in
                print(response)
                switch response.result
                {
                case .failure(let error):
                    completion(error,false,nil)
                    print(error)
                    return
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let mess = json["message"].string
                    if let data = json["data"].dictionary {
//                        if let token = data["token"]?.string,let user = data["user"]?.dictionary {
                            let avatar = data["avatar"]?.string ?? ""
                            Helper.shared.saveUserAvatar(avatar: avatar)
                            let email = data["email"]?.string ?? ""
                            Helper.shared.saveUserEmail(email: email)
                            let phone_number = data["phone_number"]?.string ?? ""
                            Helper.shared.saveUserPhone(phone: phone_number)
                            let birth_date = data["birth_date"]?.string ?? ""
                            Helper.shared.saveUserBirthDate(birth: birth_date)
                            let name = data["name"]?.string ?? ""
                            Helper.shared.saveUserName(name: name)
                            let id = data["id"]?.int ?? 0
                            Helper.shared.saveUserId(id: id)
                            completion(nil,true,mess)
                            return
                        }else{
                            completion(nil,false,mess)
                            return
                        }
//                    }
//                    completion(nil,false,mess)
//                    return
                }
            }
    }
    
    func forgotPassRequest(phone_number:String, completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?) -> Void){
        
        let parameters = [
            "phone_number" : phone_number,
        ] as [String : Any]
        
        AF.request(FORGOT_PASS_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            
            print(FORGOT_PASS_URL)
            
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let data = json["data"].dictionary {
                    if let token = data["token"]?.string {
                        Helper.shared.verifyToken = token
                        completion(nil,true,mess)
                        return
                    }else{
                        completion(nil,false,mess)
                        return
                    }
                }
                completion(nil,false,mess)
                return
            }
        }
    }
    func resetPassRequest(password:String,password_confirmation:String, completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?) -> Void){
        
        let parameters = [
            "token" : Helper.shared.verifyToken,
            "password" : password,
            "password_confirmation" : password_confirmation,
            
        ] as [String : Any]
        
        AF.request(RESET_PASS_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let data = json["data"].string {
                    completion(nil,true,data)
                    return
                    
                }else{
                    completion(nil,false,mess)
                    return
                }
            }
        }
    }
    func resetCodeRequest(completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?) -> Void){
        let parameters = [
            "token" : Helper.shared.verifyToken] as [String : Any]
        AF.request(RESET_CODE_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let data = json["data"].string {
                    completion(nil,true,data)
                    return
                }else{
                    completion(nil,false,mess)
                    return
                }
            }
        }
    }
    func updatePasswordApi(param:[String:Any],completion: @escaping(_ value:String,_ value:Bool) -> Void){
        AF.request(UPDATE_PASSWORD_URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
             print(param)
            print(response)
            switch response.result
            {
            case .failure(let error):
                completion("\(error)", false)
                print(error)
                return
            case .success(let value):
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    let message = dic["message"] as! NSString
                    completion(message as String, true)
                }else{
                    let message = dic["message"] as! NSString
                    completion(message as String, false)
                 }
            }
        }
    }
    func getMenu(completion: @escaping(_ value: [MenuM],_ value:String,_ value:Bool) -> Void){
        var dataListMenu : [MenuM] = []
        print("Main ID: " + String(Helper.shared.groupMainId))
        print("Area ID: " + String(Helper.shared.areaId))
        print(HeadersAuth)
        
        AF.request("\(GET_MENU_URL)?group_main_id=\(Helper.shared.groupMainId)&skip=0\(Helper.shared.areaId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            var menuArray = [MenuModel]()
            print("\(GET_MENU_URL)?group_main_id=\(Helper.shared.groupMainId)&skip=0\(Helper.shared.areaId)")
            print(Helper.shared.getToken() ?? "")
            print("GET_MENU_URL")
            print(response)
            switch response.result
            {
            case .failure(let error):
                completion(dataListMenu,"\(error)", false)
                print(error)
                return
            case .success(let value):
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    let data = dic["data"] as! [[String:Any]]
                    for i in data{
//                        guard let favArray = i["favArray"] else {return}
                        let id = i["id"] as Any
                        let icon = i["icon"] as Any
                        let name = i["name"] as Any
                        let description = i["description"] as Any
                        let obj = MenuM(id: id, icon: icon, name: name, description: description)
                        dataListMenu.append(obj)
                    }
                    completion(dataListMenu,"", true)
                }else{
                    let message = dic["message"] as! NSString
                    completion(dataListMenu,message as String, false)
                 }
            }
        }
    }
    func postCart(param:[String:Any],completion: @escaping(_ value:String,_ value:Bool) -> Void){

        AF.request(CART_URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in

            print(response)
            switch response.result
            {
            case .failure(let error):
                completion("\(error)", false)
                print(error)
                return
            case .success(let value):
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    var value = Helper.shared.itemCountInPopupCart
                
                    value = 0
                    Helper.shared.saveItemCountInPopupCart(count: value)
                    let data = dic["data"] as! NSDictionary
                    let total_price = data["total_price"] as! NSDictionary
                    let amount_total_price = total_price["amount"] as! String
                    Helper.shared.itemtTotalPriceInPopupCart = Double(amount_total_price) ?? 0.0
                    Helper.shared.saveItemtTotalPriceInPopupCart(price: Double(amount_total_price) ?? 0.0)
                    let products_cart = data["products_cart"] as! [[String:Any]]
                    for i in products_cart{
                        value += 1
                        Helper.shared.saveItemCountInPopupCart(count: value)
                    }
                    completion("", true)
                }else{
                    let message = dic["message"] as! NSString
                    completion(message as String, false)
                 }
            }
        }
    }
    func getCart(completion: @escaping(_ value: [CartM],_ value:String,_ value:Bool,_ value:String,_ value:String,_ value:String,_ value:String) -> Void){
        var dataList : [CartM] = []
        AF.request(CART_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
   
            print(response)
            switch response.result
            {
            case .failure(let error):
                completion(dataList,"\(error)", false,"","","","")
                print(error)
                return
            case .success(let value):
                print(self.HeadersAuth)
                print(response)
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    let data = dic["data"] as! NSDictionary
                    let delivery_price = data["delivery_price"] as! NSDictionary
                    let formatted_delivery_price = delivery_price["formatted"] as! String
                    
                    let item_price = data["item_price"] as! NSDictionary
                    let formatted_item_price = item_price["formatted"] as! String
                    
                    let total_price = data["total_price"] as! NSDictionary
                    let formatted_total_price = total_price["formatted"] as! String
                    let amount_total_price = total_price["amount"] as! String
                    Helper.shared.itemtTotalPriceInPopupCart = Double(amount_total_price) ?? 0.0
                    Helper.shared.saveItemtTotalPriceInPopupCart(price: Double(amount_total_price) ?? 0.0)
                    
                    
                    let currency_total_price = total_price["currency"] as! String
                    Helper.shared.itemtTotalCurrencyInPopupCart = currency_total_price
                    Helper.shared.saveItemtTotalCurrencyInPopupCart(currency: currency_total_price)
                    
                    
                    
                    if amount_total_price == "0"{
                        Helper.shared.saveItemCountInPopupCart(count: 0)
                        completion(dataList,"", true, formatted_delivery_price, formatted_item_price, formatted_total_price,"nil")
                    }else{
                        let products_cart = data["products_cart"] as! [[String:Any]]
                        let json = JSON(products_cart)
//                        for i in products_cart{
//                            let product_id = i["product_id"] as Any
//                            let id = i["id"] as Any
//                            let created_at = i["created_at"] as Any
//                            let name = i["name"] as Any
//                            let price = i["price"] as! NSDictionary
//                            let formatted_price = price["formatted"] as! String
//                            let quantity = i["quantity"] as Any
//                            let obj = CartM(created_at: created_at, name: name, price: formatted_price, product_id: product_id, id: id, quantity: quantity)
//                                dataList.append(obj)
//                        }
                        if let data = json.array {
                            for item in data{
                                if let modelData = item.dictionary, let cayrgory = CartM.init(dict: modelData) {
                                    dataList.append(cayrgory)
                                    Helper.shared.saveItemCountInPopupCart(count: dataList.count)
                                }
                            }
                            completion(dataList,"", true, formatted_delivery_price, formatted_item_price, formatted_total_price,"")
                        }
                    }
                }else{
                    let message = dic["message"] as! NSString
                    completion(dataList,message as String, false,"","","","")
                 }
            }
        }
    }
    func deleteItemInCart(completion: @escaping(_ value:String,_ value:Bool) -> Void){
        AF.request("\(CART_URL)/item/\(Helper.shared.productId)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            print(response)
            switch response.result
            {
            case .failure(let error):
                completion("\(error)", false)
                print(error)
                return
            case .success(let value):
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    var value = Helper.shared.itemCountInPopupCart
                    let data = dic["data"] as! NSDictionary
                    let total_price = data["total_price"] as! NSDictionary
                    let amount_total_price = total_price["amount"] as! String
                    Helper.shared.itemtTotalPriceInPopupCart = Double(amount_total_price) ?? 0.0
                    Helper.shared.saveItemtTotalPriceInPopupCart(price: Double(amount_total_price) ?? 0.0)
                    value -= 1
                    Helper.shared.saveItemCountInPopupCart(count: value)
                    
                    completion("", true)
                }else{
                    let message = dic["message"] as! NSString
                    completion(message as String, false)
                 }
            }
        }
    }
    func deleteCart(completion: @escaping(_ value:String,_ value:Bool) -> Void){
        AF.request(CART_URL, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            switch response.result
            {
            case .failure(let error):
                completion("\(error)", false)
                print(error)
                return
            case .success(let value):
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    Helper.shared.itemtTotalPriceInPopupCart =  0.0
                    Helper.shared.saveItemtTotalPriceInPopupCart(price: 0.0)
                    Helper.shared.itemCountInPopupCart = 0
                    Helper.shared.saveItemCountInPopupCart(count: 0)
                    completion("", true)
                }else{
                    let message = dic["message"] as! NSString
                    completion(message as String, false)
                 }
            }
        }
    }
    func updateQuantity(param:[String:Any],completion: @escaping(_ value:String,_ value:Bool) -> Void){
        AF.request("\(CART_URL)/item/\(Helper.shared.productId)", method: .put, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            print("UPDATE CART")
            print(param)
            print(response)
            switch response.result
            {
            case .failure(let error):
                completion("\(error)", false)
                print(error)
                return
            case .success(let value):
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    completion("", true)
                }else{
                    let message = dic["message"] as! NSString
                    completion(message as String, false)
                 }
            }
        }
    }
    func getProducts(categoryId:String,completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?,[ProductsModel]) -> Void){
        AF.request("\(GET_PRODUCTS_URL)?category=\(categoryId)&skip=0", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            print("\(GET_PRODUCTS_URL)?category=\(categoryId)&skip=0")
            print(response)
            var productsArray = [ProductsModel]()
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil,productsArray)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let data = json["data"].array {
                    for item in data{
                        if let data = item.dictionary ,let modelData = ProductsModel(dict: data) {
                            productsArray.append(modelData)
                        }
                    }
                    completion(nil,true,mess,productsArray)
                    return
                }else{
                    completion(nil,false,mess,productsArray)
                    return
                }
            }
        }
    }
    func getProductsDetails(productsId:String,completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?,[ProductsDetailsModel]) -> Void){
        AF.request("\(GET_PRODUCTS_URL)/\(productsId)/show", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            var productsArray = [ProductsDetailsModel]()
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil,productsArray)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let data = json["data"].dictionary {
                    if let modelData = ProductsDetailsModel(dict: data) {
                        productsArray.append(modelData)
                    }
                    completion(nil,true,mess,productsArray)
                    return
                }else{
                    completion(nil,false,mess,productsArray)
                    return
                }
                
            }
        }
    }
    func addAddress(area:Int,city:Int,street:String,building_name:String,building_number:String,phone_number:String,long:String,lat:String,type:String,name:String,completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?) -> Void){
        
        let parameters = [
            "area_id" : area,
            "city_id" : city,
            "street" : street,
            "building_name" : building_name,
            "building_number" : building_number,
            "phone_number" : phone_number,
            "long" : long,
            "lat" : lat,
            "address_type_id" : type,
            "name" : name
        ] as [String : Any]
        print(parameters)
        AF.request(ADDRESS_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            print(parameters)
            print(response)
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let error = json["error"].bool {
                    if error == false{
                        completion(nil,true,mess)
                        return
                    }else{
                        completion(nil,false,mess)
                        return
                    }
                }else{
                    completion(nil,false,mess)
                    return
                }
            }
        }
    }
    func getAddress(completion:@escaping (_ Value : [AddressModel],_ mess:String?,_ isSucces:Bool) -> Void){
        AF.request(ADDRESS_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            var addressArray = [AddressModel]()
            print(self.HeadersAuth)
            print(response)
            print(ADDRESS_URL)
            switch response.result
            {
            case .failure(let error):
                completion(addressArray,error as! String, false)
                print(error)
                return
            case .success(let value):
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    let data = dic["data"] as! [[String:Any]]
                    if data.count == 0{
                        completion(addressArray,"empty", true)
                    }else{
                        for i in data{
                            let id = i["id"] as Any
                            let address_type = i["address_type"] as! NSDictionary
                            let name = address_type["name"] as Any
                            
                            let area = i["area"] as! NSDictionary
                            let areaId = area["id"] as Any
                            
                            let street = i["street"] as Any
                            let building_name = i["building_name"] as Any
                            let building_number = i["building_number"] as Any
                            let phone_number = i["phone_number"] as Any
                            let long = i["long"] as Any
                            let lat = i["lat"] as Any
                            let type = i["name"] as Any
                            let obj = AddressModel(id: id, areaId: areaId, name: name, street: street, building_name: building_name, building_number: building_number, phone_number: phone_number, long: long, lat: lat, type: type)
                            addressArray.append(obj)
                            completion(addressArray,"", true)
                        }
                    }

                }else{
                   let message = dic["message"] as! NSString
                    completion(addressArray,message as String, false)
                }
            }
        }
    }
    func deleteAddress(addressId:String,completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?) -> Void){
        print(addressId)
        AF.request("\(ADDRESS_URL)/\(addressId)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
                        
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let data = json["data"].string {
                    completion(nil,true,data)
                    return
                }else{
                    completion(nil,false,mess)
                    return
                }
            }
        }
    }
//    Jawher
    func getGroupMain(complition: @escaping(_ value: [GroupMainM],_ value:String,_ value:Bool)-> Void){
        var dataList : [GroupMainM] = []
        AF.request(GET_GROUP_MAIN_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! [[String:Any]]
                        for i in data{
                            let id = i["id"] as Any
                            let icon = i["icon"] as Any
                            let name = i["name"] as Any
                            let obj = GroupMainM(id: id, icon: icon, name: name)
                            dataList.append(obj)
                            complition(dataList,"", true)
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(dataList,message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition(dataList,"Something wrong!" as String, false)
            }
         }
     }
    func getMenuShow(completion: @escaping(_ value: [MenuShowCategoryM],_ value: [BannerM],_ value:String,_ value:Bool,_ value:String,_ value:String,_ value:Int,_ value:Bool,_ value:String,_ value:Double) -> Void){
        var dataListMenu : [MenuShowCategoryM] = []
        var dataListBanner : [BannerM] = []
        AF.request("\(GET_MENU_URL)/\(Helper.shared.menuId)/show", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            var menuArray = [MenuModel]()
            print(response)
            switch response.result
            {
            case .failure(let error):
                completion(dataListMenu,dataListBanner,"\(error)", false, "", "", 0, false, "", 0.0)
                print(error)
                return
            case .success(let value):
                print(value)
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    let data = dic["data"] as! NSDictionary
                    
                    let description = data["description"] as! String
                    let icon = data["icon"] as! String
                    let id = data["id"] as! Int
                    let is_favorite = data["is_favorite"] as! Bool
                    let name = data["name"] as! String
                    let rate = data["rate"] as! Double
                    
                    let categories = data["categories"] as! [[String:Any]]
                    for i in categories{
                        let id = i["id"] as Any
                        let name = i["name"] as Any
                        let description = i["description"] as Any
                        let obj = MenuShowCategoryM(id: id, name: name, description: description)
                        dataListMenu.append(obj)
                    }
                    let images = data["images"] as! [String]
                    for i in images{
                        print(i)
                        let image = i

                        let obj = BannerM(image: image)
                        dataListBanner.append(obj)
                    }
                    completion(dataListMenu,dataListBanner,"", true, description, icon, id, is_favorite, name, rate)
                }else{
                    let message = dic["message"] as! NSString
                    completion(dataListMenu,dataListBanner,message as String, false, "", "", 0, false, "", 0.0)
                 }
            }
        }
    }
    func getCity(complition: @escaping(_ value: [CityM],_ value:String,_ value:Bool)-> Void){
        var dataList : [CityM] = []
        let HeadersAuth: HTTPHeaders = ["Accept" : "application/json",
                                        "Authorization": "Bearer\(Helper.shared.getToken() ?? "")"]
        AF.request(GET_CITY_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! [[String:Any]]
                        for i in data{
                            let id = i["id"] as Any
                            let name = i["name"] as Any
                            let obj = CityM(id: id, name: name)
                            dataList.append(obj)
                            complition(dataList,"", true)
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(dataList,message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition(dataList,"Something wrong!" as String, false)
            }
         }
     }
    func getAreaCity(complition: @escaping(_ value: [AreaM],_ value:String,_ value:Bool)-> Void){
        var dataList : [AreaM] = []
        let HeadersAuth: HTTPHeaders = ["Accept" : "application/json",
                                        "Authorization": "Bearer\(Helper.shared.getToken() ?? "")"]
        AF.request("\(GET_AREA_URL)\(Helper.shared.cityAddId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! [[String:Any]]
                        for i in data{
                            let id = i["id"] as Any
                            let name = i["name"] as Any
                            let obj = AreaM(id: id, name: name)
                            dataList.append(obj)
                            complition(dataList,"", true)
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(dataList,message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition(dataList,"Something wrong!" as String, false)
            }
         }
     }
    func getArea(complition: @escaping(_ value: [AreaM],_ value:String,_ value:Bool)-> Void){
        var dataList : [AreaM] = []
        let HeadersAuth: HTTPHeaders = ["Accept" : "application/json",
                                        "Authorization": "Bearer\(Helper.shared.getToken() ?? "")"]
        AF.request(ADDRESS_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
            print(ADDRESS_URL)
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! [[String:Any]]
                        for i in data{
                            let id = i["id"] as Any
                            let address_type = i["address_type"] as! NSDictionary
                            let name = address_type["name"] as Any
                            let obj = AreaM(id: id, name: name)
                            dataList.append(obj)
                            complition(dataList,"", true)
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(dataList,message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition(dataList,"Something wrong!" as String, false)
            }
         }
     }
    func getProductsDetails2(productsId:String,completion:@escaping (_ value:[ItemMinMaxM],_ value:[ProductsDetailsM],_ mess:String,_ isSucces:Bool) -> Void){
        var priceFormattedMain = ""
        var iconMain = ""
        var descriptionMain = ""
        var nameMain = ""
        var idMain = 0
        AF.request("\(GET_PRODUCTS_URL)/\(productsId)/show", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            var dataList = [ProductsDetailsM]()
            var dataListItemMax = [ItemMinMaxM]()
            print(self.HeadersAuth)
            print("\(GET_PRODUCTS_URL)/\(productsId)/show")
            print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    print(value)
                    let dic = value as! NSDictionary
                    let data = dic["data"] as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let items = data["items"] as! [[String:Any]]
                        for i in items{
                            let max = i["max"] as! NSNumber
                            let min = i["min"] as! NSNumber
                            let id = i["id"] as! NSNumber
                            let obj = ItemMinMaxM(max: max, min: min, id: id)
                            dataListItemMax.append(obj)
                        }
                        let json = JSON(data)
                        print(json)
                        if let results = json["items"].array {
                            print(results)
                            for item in results{
                                if let data = item.dictionary, let categoryData = ProductsDetailsM.init(dict: data)
                                {
                                    dataList.append(categoryData)
                                }
                            }
                        }
                        completion(dataListItemMax,dataList, "", true)
                    }else{
                        let message = data["massage"] as! NSString
                        completion(dataListItemMax,dataList, message as? String ?? "", false)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    func getFavorite(complition: @escaping(_ value: [FavoritesM],_ value:String,_ value:Bool)-> Void){
        var dataList : [FavoritesM] = []
        AF.request(GET_MENU_URL + FAVORITE_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
            print("Favorite get")
             print(GET_MENU_URL + FAVORITE_URL)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! [[String:Any]]
                        if data.count == 0{
                            complition(dataList,"Favorite list is empty", false)
                        }else{
                            for i in data{
                                let id = i["id"] as Any
                                let icon = i["icon"] as Any
                                let name = i["name"] as Any
                                let description = i["description"] as Any
                                let obj = FavoritesM(description: description, name: name, icon: icon, id: id)
                                dataList.append(obj)
                                complition(dataList,"", true)
                            }
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(dataList,message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition(dataList,"Something wrong!" as String, false)
            }
         }
     }
    func postFavorite(favoriteId:String,completion:@escaping (_ error: Error?,_ isSucces:Bool,_ mess:String?) -> Void){
        print(favoriteId)
        AF.request("\(GET_MENU_URL)/\(favoriteId)\(FAVORITE_URL)", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
                        print("\(GET_MENU_URL)/\(favoriteId)\(FAVORITE_URL)")
            switch response.result
            {
            case .failure(let error):
                completion(error,false,nil)
                print(error)
                return
            case .success(let value):
                let json = JSON(value)
                print(json)
                let mess = json["message"].string
                if let data = json["data"].string {
                    completion(nil,true,data)
                    return
                }else{
                    completion(nil,false,mess)
                    return
                }
            }
        }
    }
    func getReview(complition: @escaping(_ value: [ReviewM],_ value:String,_ value:Bool)-> Void){
        var dataList : [ReviewM] = []
        AF.request("\(GET_MENU_URL)/\(Helper.shared.menuId)\(REVIEW_URL)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
            print("\(GET_MENU_URL)/\(Helper.shared.menuId)\(REVIEW_URL)")
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! [[String:Any]]
                        if data.count == 0{
                            complition(dataList,"Review list is empty", false)
                        }else{
                            for i in data{
                                let comment = i["comment"] as Any
                                let rate = i["rate"] as Any
                                let user = i["user"] as! NSDictionary
                                let userName = user["name"] as Any
                                let avatar = user["avatar"] as Any
                                let obj = ReviewM(comment: comment, userName: userName, avatar: avatar, rate: rate)
                                dataList.append(obj)
                                complition(dataList,"", true)
                            }
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(dataList,message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition(dataList,"Something wrong!" as String, false)
            }
         }
     }
    func postReview(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        var dataList : [ReviewM] = []
        AF.request("\(GET_MENU_URL)/\(Helper.shared.menuId)\(REVIEW_URL)", method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        complition("", true)
                    }else{
                       let message = dic["message"] as! NSString
                       complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func getNotification(complition: @escaping(_ value: [NotificationM],_ value:String,_ value:Bool)-> Void){
        var dataList : [NotificationM] = []
        AF.request(NOTIFICATION_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! [[String:Any]]
                        if data.count == 0{
                            complition(dataList,"Review list is empty", false)
                        }else{
                            for i in data{
                                let created_at = i["created_at"] as Any
                                let description = i["description"] as Any
                                let icon = i["icon"] as Any
                                let id = i["id"] as Any
                                let name = i["name"] as Any
                                let type = i["type"] as Any
                                let obj = NotificationM(created_at: created_at, description: description, icon: icon, id: id, name: name, type: type)
                                dataList.append(obj)
                                complition(dataList,"", true)
                            }
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(dataList,message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition(dataList,"Something wrong!" as String, false)
            }
         }
     }
    func postOrder(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        AF.request(ORDER_URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
            print(param)
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        Helper.shared.itemCountInPopupCart = 0
                        Helper.shared.saveItemCountInPopupCart(count: 0)
                        complition("", true)
                    }else{
                       let message = dic["message"] as! NSString
                       complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func getOrder(complition: @escaping(_ value: [OrderM],_ value:String,_ value:Bool)-> Void){
        var dataList : [OrderM] = []
        AF.request(ORDER_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! [[String:Any]]
                        if data.count == 0{
                            complition(dataList,"Order list is empty", false)
                        }else{
                            for i in data{
                                let id = i["id"] as Any
                                let menu = i["menu"] as! NSDictionary
                                let nameMenu = menu["name"] as Any
                                let iconMenu = menu["icon"] as Any
                                let date_order = i["date_order"] as Any
                                let time_order = i["time_order"] as Any
                                let status = i["status"] as Any
                                let address = i["address"] as Any
                                let count_items = i["count_items"] as Any
                                let total_price = i["total_price"] as! NSDictionary
                                let price = total_price["formatted"] as Any
                                let obj = OrderM(id: id, nameMenu: nameMenu, iconMenu: iconMenu, date_order: date_order, time_order: time_order, status: status, address: address, count_items: count_items, price: price)
                                dataList.append(obj)
                                complition(dataList,"", true)
                            }
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(dataList,message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition(dataList,"Something wrong!" as String, false)
            }
         }
     }
    func getOrderDetalis(complition: @escaping(_ id:Int,_ payment:String,_ status:String,_ dateTime:String,_ startTime:String,_ endTime:String,_ addressOrder:String,_ phone_number:String,_ nameMenu:String,_ iconMenu:String,_ total_priceF:String,_ sub_priceF:String,_ delivery_priceF:String,_ ordername:String,_ value:String,_ value:Bool)-> Void){
        var dataList : [OrderM] = []
        var pname = ""
        AF.request("\(ORDER_URL)/\(Helper.shared.orderId)/show", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
            print("\(ORDER_URL)/\(Helper.shared.orderId)/show")
             print(response)
            print(Helper.shared.getToken() ?? "")
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! NSDictionary
                        if data.count == 0{
                            complition(0,"","","","","","","","","","","","","","Order list is empty", false)
                        }else{
                            let id = data["id"] as? Int ?? 0
                            let payment = data["payment"]as? String ?? ""
                            let status = data["status"]as? String ?? ""
                            let date = data["date_order"] as? String ?? ""
                            let time = data["time_order"] as? String ?? ""
                            
                            let startTime = data["start_time"] as? String ?? ""
                            let endTime = data["end_time"] as? String ?? ""
                            
                            let street = data["street"] as? String ?? ""
                            let building_name = data["building_name"]as? String ?? ""
                            let building_number = data["building_number"]as? String ?? ""
                            let long = data["long"] as Any
                            let lat = data["lat"] as Any
                            let menu = data["menu"] as! NSDictionary
                            let nameMenu = menu["name"] as? String ?? ""
                            let iconMenu = menu["icon"] as? String ?? ""
                            let address = data["address"] as! NSDictionary
                            let city = address["city"] as! NSDictionary
                            let nameCity = city["name"] as? String ?? ""
                            let area = address["area"] as! NSDictionary
                            let nameArea = area["name"] as? String ?? ""
                            let phone_number = address["phone_number"]as? String ?? ""
                            let addressOrder = "\(nameArea), \(nameCity), \(street)"
                            let dateTime = "\(date) \(time)"
                            let total_price = data["total_price"] as! NSDictionary
                            let total_priceF = total_price["formatted"] as? String ?? ""
                            let sub_price = data["sub_price"] as! NSDictionary
                            let sub_priceF = sub_price["formatted"] as? String ?? ""
                            let delivery_price = data["delivery_price"] as! NSDictionary
                            let delivery_priceF = delivery_price["formatted"] as? String ?? ""
                             let products = data["products"] as! [[String:Any]]
                            for i in products {
                                let name = i["name"] as? String ?? ""
                                pname = name
                            }
                            print(pname)
                                complition(id,payment,status,dateTime,startTime,endTime,addressOrder,phone_number,nameMenu,iconMenu,total_priceF,sub_priceF,delivery_priceF,pname,"", true)
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(0,"","","","","","","","","","","","",pname,message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition(0,"","","","","","","","","","","","","","Something wrong!" as String, false)
            }
         }
     }
    func payment(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        AF.request(PAYMENT_URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
            print(Helper.shared.getToken() ?? 0)
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! NSDictionary
                        let redirect_url = data["redirect_url"] as? String ?? ""
                        let message = data["message"] as? String ?? ""
                        if message == "Duplicate Request"{
                            complition("YOUR REQUEST HAS TIMED OUT DUE TO SECURITY REASONS. PLEASE TRY AGAIN AT A LATER TIME.", false)
                        }else{
                            complition(redirect_url, true)
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func promoCodeApi(param:[String:Any],complition: @escaping(_ total_priceF:String,_ sub_priceF:String,_ delivery_priceF:String,_ coupon_priceF:String,_ coupon_type:String,_ value:String,_ value:Bool)-> Void){
        AF.request(PROMO_CODE_URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! NSDictionary
                        if data.count == 0{
                            complition("","","","","","", true)
                        }else{
                            let total_price = data["total_price"] as! NSDictionary
                            let total_priceF = total_price["formatted"] as? String ?? ""
                            let amount_total_price = total_price["amount"] as! String
                            Helper.shared.itemtTotalPriceInPopupCart = Double(amount_total_price) ?? 0.0
                            
                            let coupon_type = data["coupon_type"] as? String ?? ""
                            let sub_price = data["item_price"] as! NSDictionary
                            let sub_priceF = sub_price["formatted"] as? String ?? ""
                            let delivery_price = data["delivery_price"] as! NSDictionary
                            let delivery_priceF = delivery_price["formatted"] as? String ?? ""
                            let coupon = data["coupon"] as! NSDictionary
                            let coupon_priceF = coupon["formatted"] as? String ?? ""
                            complition(total_priceF,sub_priceF,delivery_priceF,coupon_priceF,coupon_type,"", true)
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition("","","","","",message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("","","","","","Something wrong!" as String, false)
            }
         }
     }
    func checkAppleLoginApi(complition: @escaping(_ value:String,_ value:Bool)-> Void){
        AF.request(CHECK_APPLE_LOGIN_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        complition("", true)
                    }else{
//                       let message = dic["message"] as! NSString
                       complition("", false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func getOrderTime(complition: @escaping(_ value: [OrderTimeM],_ value:String,_ value:Bool)-> Void){
        var dataList : [OrderTimeM] = []
        AF.request(ORDER_TIME_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! [[String:Any]]
                        for i in data{
                            let start_time = i["start_time"] as Any
                            let end_time = i["end_time"] as Any
                            let obj = OrderTimeM(start_time: start_time, end_time: end_time)
                            dataList.append(obj)
                            complition(dataList,"", true)
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(dataList,message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition(dataList,"Something wrong!" as String, false)
            }
         }
     }
    func deleteAccount(completion: @escaping (_ error: Error?,_ isSucces:Bool, _ mess:String?)->()){

          AF.request(DELETE_Account_URL, method: .post, parameters: nil, encoding: URLEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            print(response)
              switch response.result {
              case .failure(let error):
                  completion(error,false,nil)
                  print(error)
                  return
              case .success(let value):
                  let json = JSON(value)
                  print(json)
                  let mess = json["message"].string
                  if let status = json["success"].string {
                      if status == "1"{
                          completion(nil,true,mess)
                          return
                      }else{
                          completion(nil,false,mess)
                          return
                      }
                  }
              }
              completion(nil,false,nil)
              return
          }
      }
    func versionUpdate(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        AF.request(VERSION_UPDATE, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        complition("", true)
                    }else{
                       let message = dic["message"] as! NSString
                       complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    
    
    func getCard(completion:@escaping (_ Value : [CardM],_ mess:String?,_ isSucces:Bool) -> Void){
        AF.request(Card_url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            var CardArr = [CardM]()
            print(self.HeadersAuth)
            print(response)
            switch response.result
            {
            case .failure(let error):
                completion(CardArr,error as! String, false)
                print(error)
                return
            case .success(let value):
                let dic = value as! NSDictionary
                let error = dic["error"] as! NSNumber
                if error == 0{
                    let data = dic["data"] as! [[String:Any]]
                    if data.count == 0{
                        completion(CardArr,"empty", true)
                    }else{
                        for i in data{
                            let card_scheme = i["card_scheme"] as? String ?? ""
                            let payment_description = i["payment_description"] as? String ?? ""
                           let id = i["id"] as? Int ?? 0
                            let obj = CardM(card_scheme: card_scheme, payment_description: payment_description,id:id)
                            CardArr.append(obj)
                            completion(CardArr,"", true)
                        }
                    }

                }else{
                   let message = dic["message"] as! NSString
                    completion(CardArr,message as String, false)
                }
            }
        }
    }
    func pay_order_t(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        AF.request(payment_pay_order_t_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! NSDictionary
                        let redirect_url = data["redirect_url"] as? String ?? ""
                        let message = data["message"] as? String ?? ""
                        if message == "Duplicate Request"{
                            complition("YOUR REQUEST HAS TIMED OUT DUE TO SECURITY REASONS. PLEASE TRY AGAIN AT A LATER TIME.", false)
                        }else{
                            complition(redirect_url, true)
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func CheckOut(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        AF.request(CheckOut_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! NSDictionary
                        let redirect_url = data["redirect_url"] as? String ?? ""
                        let message = data["message"] as? String ?? ""
                        if message == "Duplicate Request"{
                            complition("YOUR REQUEST HAS TIMED OUT DUE TO SECURITY REASONS. PLEASE TRY AGAIN AT A LATER TIME.", false)
                        }else{
                            complition(redirect_url, true)
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func delete_card(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        AF.request(delete_card_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            print(delete_card_url)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
//                        let data = dic["data"] as! NSDictionary
//                        let redirect_url = data["redirect_url"] as? String ?? ""
//                        let message = data["message"] as? String ?? ""
//                        if message == "Duplicate Request"{
//                            complition("YOUR REQUEST HAS TIMED OUT DUE TO SECURITY REASONS. PLEASE TRY AGAIN AT A LATER TIME.", false)
//                        }else{
                            complition("", true)
//                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    func Edit_address(param:[String:Any],completion: @escaping(_ value:String,_ value:Bool) -> Void){
        
        AF.request("\(update_address_url)\(Helper.shared.Address_Id)", method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON{ (response) in
            print(param)
            print(response)
            print("\(update_address_url)\(Helper.shared.Address_Id)")
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            
            
            if statusCode == 200 || statusCode == 422 {
                switch response.result
                {
                case .failure(let error):
                    completion("\(error)", false)
                    print(error)
                    return
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
//                        let data = dic["data"] as! NSDictionary
                      
                        completion("", true)
                    }else{
                        let message = dic["message"] as! NSString
                        completion(message as String, false)
                    }
                }
            }else{
                completion("Something wrong!" as String, false)
            }
        }
    }
    
    
    
    
    
    func get_order_id(param:[String:Any],complition: @escaping(_ value:Any,_ value:Bool)-> Void){
        AF.request(checkout_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
            print(Helper.shared.getToken() ?? 0)
             print(response)
            print(param)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200  {
                switch response.result {
                case .success(let value):
                let order_id = response.value ?? ""
                print(order_id)
                complition(order_id, true)
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
    
    func tokenize_request_t(param:[String:Any],complition: @escaping(_ value:String,_ value:Bool)-> Void){
        AF.request(tokenize_request_t_url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: HeadersAuth).responseJSON { (response) in
             print(response)
            let statusCode = response.response?.statusCode
            print(statusCode! as Int)
            if statusCode == 200 || statusCode == 422 {
                switch response.result {
                case .success(let value):
                    let dic = value as! NSDictionary
                    let error = dic["error"] as! NSNumber
                    if error == 0{
                        let data = dic["data"] as! NSDictionary
                        let redirect_url = data["redirect_url"] as? String ?? ""
                        let message = data["message"] as? String ?? ""
                        if message == "Duplicate Request"{
                            complition("YOUR REQUEST HAS TIMED OUT DUE TO SECURITY REASONS. PLEASE TRY AGAIN AT A LATER TIME.", false)
                        }else{
                            complition(redirect_url, true)
                        }
                    }else{
                       let message = dic["message"] as! NSString
                       complition(message as String, false)
                    }
                case .failure(let error):
                    print(error)
                }
            }else{
                complition("Something wrong!" as String, false)
            }
         }
     }
}
