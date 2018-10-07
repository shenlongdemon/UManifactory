//
//  BLEBeacon.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 10/7/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
class BLEBeacon: IObject,Mappable {
    var bluetoothId: String = ""
    var beaconId : String = ""
    
    override init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.bluetoothId <- map["bluetoothId"]
        self.beaconId <- map["beaconId"]
    }
}
