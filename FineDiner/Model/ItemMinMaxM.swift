//
//  ItemMinMaxM.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 15/05/2022.
//

import Foundation
import SwiftyJSON

class ItemMinMaxM {
    var max : Any
    var min : Any
    var id : Any
    var currentSelectedNew = 0

    init(max:Any,min:Any,id:Any) {
        self.max = max
        self.min = min
        self.id = id
    }
}
