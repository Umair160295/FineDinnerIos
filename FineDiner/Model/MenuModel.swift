//
//  UserModel.swift
//  FineDiner
//
//  Created by iOS Developer on 25/12/2021.
//

import Foundation
import SwiftyJSON

class MenuModel: NSObject {

    var id:Int
    var name:String
    var icon:String
    var title:String
    var address:String
    var categories = [CategoriesModel]()
    init?(dict: Dictionary<String, JSON>)
    {
        let id =  dict["id"]?.int ?? 0
        let name =  dict["name"]?.string ?? ""
        let icon =  dict["icon"]?.string ?? ""
        let title =  dict["title"]?.string ?? ""
        let address =  dict["address"]?.string ?? ""
        let categories = dict["categories"]?.array ?? []
        
        self.id = id
        self.name = name
        self.icon = icon
        self.title = title
        self.address = address
        for item in categories {
            print(item)
            if let data = item.dictionary, let menuData = CategoriesModel.init(dict: data)
            {
                self.categories.append(menuData)
            }
        }
    }
}
class CategoriesModel: NSObject {
    
    var id:Int
    var name:String
    var categoriesDesc:String
 
    init?(dict: Dictionary<String, JSON>)
    {
        let id =  dict["id"]?.int ?? 0
        let name =  dict["name"]?.string ?? ""
        let categoriesDesc =  dict["description"]?.string ?? ""
    
        
        self.id = id
        self.name = name
        self.categoriesDesc = categoriesDesc
    
    }
}
