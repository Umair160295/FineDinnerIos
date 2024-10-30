//
//  CardM.swift
//  FineDiner
//
//  Created by mustafa khallad on 24/10/2022.
//

import Foundation
class CardM{
    var id : Int
    var card_scheme:String
    var payment_description:String
    var select = "no"
    init(card_scheme:String,payment_description:String,id:Int){
        self.id = id
        self.card_scheme = card_scheme
        self.payment_description = payment_description
        
    }
}
