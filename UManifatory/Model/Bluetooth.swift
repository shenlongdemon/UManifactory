//
//  Bluetooth.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 5/17/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//


import Foundation
import Alamofire
import ObjectMapper

class Bluetooth: IObject, Mappable {
    var name: String = ""
    var localName: String = ""
    override init() {
        super.init()
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.localName     <- map["localName"]
        self.id <- map["id"]
        self.name   <- map["name"]
    }
    
}
