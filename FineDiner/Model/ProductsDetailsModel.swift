//
//  ProductsDetailsModel.swift
//  FineDiner
//
//  Created by iOS Developer on 06/01/2022.
//

import Foundation
import SwiftyJSON
class ProductsDetailsModel: NSObject {

    var id:Int
    var name:String
    var icon:String
    var productDescription:String
    var is_favorite:Bool
    var reviews:Int
    var amount:String
    var formatted:String
    var currency:String
    var item = [ProductsDetailsModel]()
    
    init?(dict: Dictionary<String, JSON>)
    {
        let id =  dict["id"]?.int ?? 0
        let name =  dict["name"]?.string ?? ""
        let icon =  dict["icon"]?.string ?? ""
        let productDescription =  dict["description"]?.string ?? ""
        let is_favorite =  dict["is_favorite"]?.bool ?? false
        let reviews =  dict["reviews"]?.int ?? 0
        let price = dict["price"]?.dictionary
        let amount = price?["amount"]?.string ?? ""
        let formatted = price?["formatted"]?.string ?? ""
        let currency = price?["currency"]?.string ?? ""
        let item = dict["items"]?.array ?? []

        self.id = id
        self.name = name
        self.icon = icon
        self.productDescription = productDescription
        self.is_favorite = is_favorite
        self.reviews = reviews
        self.amount = amount
        self.formatted = formatted
        self.currency = currency
        for product in item {
            if let data = product.dictionary, let menuData = ProductsDetailsModel.init(dict: data)
            {
                self.item.append(menuData)
            }
        }
    }
}
