//
//  ScanQRItem.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/25/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
class ScanQRItem: Mappable {
    var type: Enums.ScanQRItemType = Enums.ScanQRItemType.unknown
    var item : AnyObject?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        self.type <- map["type"]
        self.item <- map["item"]
    }
}
