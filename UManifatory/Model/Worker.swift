//
//  Worker.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/18/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class Worker: IObject, Mappable {
    var owner: User!
    var activities : [Activity] = []
    var materialId: String = ""
    var materialOwnerId: String = ""
    override init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.owner     <- map["owner"]
        self.activities   <- map["activities"]
        for (_, activity) in self.activities.enumerated() {
            activity.worker = self
        }
    }
}
