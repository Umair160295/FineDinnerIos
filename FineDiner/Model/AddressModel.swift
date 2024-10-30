//
//  AddressModel.swift
//  FineDiner
//
//  Created by iOS Developer on 06/01/2022.
//

import Foundation
import SwiftyJSON

//class AddressModel: NSObject {
//
//    var id:Int
//    var area:String
//    var street:String
//    var building_name:String
//    var building_number:String
//    var phone_number:String
//    var long:Float
//    var lat:Float
//    var type:String
//
//    init?(dict: Dictionary<String, JSON>)
//    {
//        let id =  dict["id"]?.int ?? 0
//        let area =  dict["area"]?.string ?? ""
//        let street =  dict["street"]?.string ?? ""
//        let building_name =  dict["building_name"]?.string ?? ""
//        let building_number =  dict["building_number"]?.string ?? ""
//        let phone_number =  dict["phone_number"]?.string ?? ""
//        let long = dict["long"]?.float ?? 0.0
//        let lat = dict["lat"]?.float ?? 0.0
//        let type = dict["type"]?.string ?? ""
//
//        self.id = id
//        self.area = area
//        self.street = street
//        self.building_name = building_name
//        self.building_number = building_number
//        self.phone_number = phone_number
//        self.long = long
//        self.lat = lat
//        self.type = type
//    }
//}


class AddressModel {
    var id:Any
    var areaId:Any
    var name:Any
    var street:Any
    var building_name:Any
    var building_number:Any
    var phone_number:Any
    var long:Any
    var lat:Any
    var type:Any
    var is_select = "no"
    
    
    init(id:Any, areaId:Any, name:Any, street:Any,building_name:Any, building_number:Any, phone_number:Any, long:Any, lat:Any, type:Any) {
        self.id = id
        self.areaId = areaId
        self.name = name
        self.street = street
        self.building_name = building_name
        self.building_number = building_number
        self.phone_number = phone_number
        self.long = long
        self.lat = lat
        self.type = type
    }
}
