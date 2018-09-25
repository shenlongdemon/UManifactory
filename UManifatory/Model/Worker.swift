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
    var status : Enums.TaskStatus = Enums.TaskStatus.not_start
    override init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.owner     <- map["owner"]
        self.activities   <- map["activities"]
        self.status   <- (map["status"],EnumTransform<Enums.TaskStatus>())
        for (_, activity) in self.activities.enumerated() {
            activity.worker = self
        }
    }
    func getActivityImages() -> [String] {
        return self.activities.flatMap({ (act) -> [String] in
            return act.images
        })
        
    }
}
