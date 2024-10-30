//
//  ProductsDetailsM.swift
//  FineDiner
//
//  Created by QTechnetworks on 17/02/2022.
//

import Foundation
import SwiftyJSON

//class ProductsDetailsM {
//    var icon : Any
//    var type : Any
//    var id : Any
//    var name : Any
//    var description : Any
//    var price : Any
//    var is_select = "no"
//
//    init(icon:Any,type:Any,id:Any,name:Any,description:Any,price:Any) {
//        self.icon = icon
//        self.type = type
//        self.id = id
//        self.name = name
//        self.description = description
//        self.price = price
//    }
//}



class ProductsDetailsM:NSObject {
    var id : Any
    var descriptionProduct : Any
    var max : Any
    var min : Any
    var name : Any
    var ItemArray = [ItemM]()
    var currentSelected = 0
    
    init?(dict: Dictionary<String, JSON>)
    {
        let id = dict["id"]?.int
        let descriptionProduct = dict["description"]?.string
        let max = dict["max"]?.int
        let min = dict["min"]?.int
        let name = dict["name"]?.string
        let items = dict["items"]?.array

        self.id = id as Any
        self.descriptionProduct = descriptionProduct
        self.max = max
        self.min = min
        self.name = name
        for item in items! {
            if let data = item.dictionary, let categoryData = ItemM.init(dict: data)
            {
                self.ItemArray.append(categoryData)
            }
        }
    }
}


class ItemM {
    var descriptionItem : Any
    var id : Any
    var product_id : Any
    var name : Any
    var type : Any
    var is_select = "no"
    
    var formatted : Any
    var amount : Any
    

    
    init?(dict: Dictionary<String, JSON>)
    {
        let descriptionItem = dict["description"]?.string
        let id = dict["id"]?.int
        let product_id = dict["product_id"]?.int
        let name = dict["name"]?.string
        let type = dict["type"]?.string
        
        let price = dict["price"]?.dictionary
        let formatted = price?["formatted"]?.string
        let amount = price?["amount"]?.string

        self.descriptionItem = descriptionItem
        self.id = id
        self.product_id = product_id
        self.name = name
        self.type = type
        
        self.formatted = formatted
        self.amount = amount

    }

}
