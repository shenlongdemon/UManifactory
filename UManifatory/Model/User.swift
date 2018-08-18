//
//  User.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class User: IObject, Mappable {
    var phone: String = ""
    var password: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var zipCode: String = ""
    var state: String = ""
    var country: String = ""
    var image: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.firstName     <- map["firstName"]
        self.lastName     <- map["lastName"]
        self.zipCode     <- map["zipCode"]
        self.state     <- map["state"]
        self.country     <- map["country"]
        self.image     <- map["image"]
        self.phone     <- map["phone"]
        self.password     <- map["password"]
    }
    func getImage() -> UIImage? {
        return Util.getImage(data64: self.image)
    }
}

