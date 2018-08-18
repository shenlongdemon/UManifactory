//
//  APIModel.swift
//  ugutaDID
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class ApiModel: Mappable{
    var Status: Int = 1
    var Data: Any? = nil
    var Message: String = ""
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.Status     <- map["Status"]
        self.Data <- map["Data"]
        self.Message   <- map["Message"]
    }
    
}

