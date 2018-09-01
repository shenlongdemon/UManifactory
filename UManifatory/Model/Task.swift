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
    var code: String = ""
    var workers : [Worker] = []
    var materialId: String = ""
    var materialOwnerId: String = ""
    override init() {
        
    }
    required init?(map: Map) {
        
    }
    func setMaterialId(materialId: String) {
        self.materialId = materialId
        for (_, worker) in self.workers.enumerated() {
            worker.materialId = self.materialId            
        }
    }
    func setMaterialOwnerId(materialOwnerId: String) {
        self.materialOwnerId = materialOwnerId
        for (_, worker) in self.workers.enumerated() {
            worker.materialOwnerId = self.materialOwnerId
        }
    }
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name     <- map["name"]
        self.image   <- map["image"]
        self.code   <- map["code"]
        self.workers   <- map["workers"]
        
        for (_, worker) in self.workers.enumerated() {
            for (_, activity) in worker.activities.enumerated() {
                activity.logoTask = self.image
                
            }
            
        }
    }
    
    func isIAmOwner() -> Bool{
        let user = StoreUtil.getUser()!
        return self.workers.contains(where: { (worker) -> Bool in
            return worker.owner.id == user.id
        })
    }
    
    func getWorker(id: String) -> Worker?{
        let worker = self.workers.first { (w) -> Bool in
            let wk = w as! Worker
            return wk.owner.id == id
        }
        return worker
    }
    
}
