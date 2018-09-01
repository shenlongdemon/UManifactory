//
//  Category.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/25/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Foundation
import Alamofire
import ObjectMapper

class Category: IObject, Mappable {
    var value: String = ""
    var icon: String = ""
    override init() {
        super.init()
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.value     <- map["value"]
        self.id <- map["id"]
        self.icon   <- map["icon"]
    }
    
}
