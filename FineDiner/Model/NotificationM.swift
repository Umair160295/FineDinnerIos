//
//  NotificationM.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 21/04/2022.
//

import Foundation
import SwiftyJSON

class NotificationM {
    var created_at : Any
    var description : Any
    var icon : Any
    var id : Any
    var name : Any
    var type : Any
    
    init(created_at:Any,description:Any,icon:Any,id:Any,name:Any,type:Any) {
        self.created_at = created_at
        self.description = description
        self.icon = icon
        self.id = id
        self.name = name
        self.type = type
    }
}
