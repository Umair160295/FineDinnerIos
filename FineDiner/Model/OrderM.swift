//
//  OrderM.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 24/04/2022.
//

import Foundation
import SwiftyJSON

class OrderM {
    var id : Any
    var nameMenu : Any
    var iconMenu : Any
    var date_order : Any
    var time_order : Any
    var status : Any
    var address : Any
    var count_items : Any
    var price : Any
    
    init(id:Any,nameMenu:Any,iconMenu:Any,date_order:Any,time_order:Any,status:Any,address:Any,count_items:Any,price:Any) {
        self.id = id
        self.nameMenu = nameMenu
        self.iconMenu = iconMenu
        self.date_order = date_order
        self.time_order = time_order
        self.status = status
        self.address = address
        self.count_items = count_items
        self.price = price
    }
}
