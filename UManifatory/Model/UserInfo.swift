//
//  UserInfo.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/23/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import ObjectMapper

class UserInfo: User {
    var code: String = ""
    var position: Position!
    var weather: Weather!
    var time: Int64 = 0
    var index:Int = 0
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.code     <- map["code"]
        self.time     <- map["time"]
        self.position   <- map["position"]
        self.weather     <- map["weather"]
    }
}
