//
//  ReviewM.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 21/04/2022.
//

import Foundation
import SwiftyJSON

class ReviewM {
    var comment : Any
    var userName : Any
    var avatar : Any
    var rate : Any
    
    init(comment:Any,userName:Any,avatar:Any,rate:Any) {
        self.comment = comment
        self.userName = userName
        self.avatar = avatar
        self.rate = rate
    }
}
