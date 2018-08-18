//
//  BLEDevice.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 5/10/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
class BLEDevice: IObject, Mappable  {
    var name: String = ""
    var localName : String = ""
    var ownerId : String = ""
    var coord : BLECoord!
    override init() {
        super.init()
    }
    func getDistance() -> String {
        let text = String(format: "%.1fm", arguments: [self.coord.distance])
        return text
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {        
        self.id     <- map["id"]
        self.name     <- map["name"]
        self.localName   <- map["localName"]
        self.coord     <- map["coord"]
        self.ownerId     <- map["ownerId"]
    }
}
