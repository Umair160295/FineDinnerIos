//
//  ProductsModel.swift
//  FineDiner
//
//  Created by iOS Developer on 06/01/2022.
//

import Foundation
import SwiftyJSON

class ProductsModel: NSObject {

    var type:String
    var id:Int
    var name:String
    var icon:String
    var productDescription:String
    var is_favorite:Bool
    var reviews:Int
    var amount:String
    var formatted:String
    var currency:String

    init?(dict: Dictionary<String, JSON>)
    {
        let type =  dict["type"]?.string ?? ""
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
        self.type = type
        self.id = id
        self.name = name
        self.icon = icon
        self.productDescription = productDescription
        self.is_favorite = is_favorite
        self.reviews = reviews
        self.amount = amount
        self.formatted = formatted
        self.currency = currency
    }
}
