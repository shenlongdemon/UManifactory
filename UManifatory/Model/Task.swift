//
//  Task.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/18/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
class Task: IObject, Mappable {
    var name: String = ""
    var image: String = ""
    var workers : [Worker] = []
    
    override init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name     <- map["name"]
        self.image   <- map["image"]
        self.workers   <- map["workers"]
    }
    func getWorker(id: String) -> Worker?{
        let worker = self.workers.first { (w) -> Bool in
            let wk = w as! Worker
            return wk.owner.id == id
        }
        return worker
    }
}
