//
//  CartM.swift
//  FineDiner
//
//  Created by QTechnetworks on 14/02/2022.
//

import Foundation
import SwiftyJSON

class CartM: NSObject {

    var created_at : Any
    var name : Any
    var formatted_price : Any
    var product_id : Any
    var id : Any
    var quantity : Any
    var attributesArr = [AttributesM]()
    
    init?(dict: Dictionary<String, JSON>)
    {
        let created_at = dict["created_at"]?.int
        let name = dict["name"]?.string
        let price = dict["price"]?.dictionary
        let formatted_price = price?["formatted"]?.string
        let product_id = dict["product_id"]?.int
        let id = dict["id"]?.int
        let quantity = dict["quantity"]?.int
        let attributes = dict["attributes"]?.array
        
        self.created_at = created_at as Any
        self.name = name as Any
        self.formatted_price = formatted_price as Any
        self.product_id = product_id as Any
        self.id = id as Any
        self.quantity = quantity as Any
        for item in attributes! {
            print(item)
            if let data = item.dictionary, let menuData = AttributesM.init(dict: data)
            {
                self.attributesArr.append(menuData)
            }
        }
    }
}


class AttributesM{
    var name : String
    var formatted : String
    var amount : String
    
    init?(dict: Dictionary<String, JSON>){
        
        let name = dict["name"]?.string
        
        let price = dict["price"]?.dictionary
        let formatted = price?["formatted"]?.string
        let amount = price?["amount"]?.string
        
        self.name = name!
        self.formatted = formatted!
        self.amount = amount!
    }
}
