//
//  File.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/15/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//


import Foundation
import Alamofire
import ObjectMapper
class Material: IObject, Mappable {
    var name : String = ""
    var ownerId : String = ""
    var description : String = ""
    var code : String = ""
    var bluetooth : String = ""
    var tasks : [Task] = []
    var image : String = ""
    var createdAt: Int64 = 0
    var updatedAt: Int64 = 0
    override init() {
        super.init()
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {        
        self.id <- map["id"]
        self.name   <- map["name"]
        self.ownerId   <- map["ownerId"]
        self.description   <- map["description"]
        self.image   <- map["image"]
        self.code   <- map["code"]
        self.bluetooth   <- map["bluetooth"]
        self.tasks   <- map["tasks"]
        self.createdAt   <- map["createdAt"]
        self.updatedAt   <- map["updatedAt"]
        for (_, task) in self.tasks.enumerated() {
            task.setMaterialId(materialId: self.id)
            task.setMaterialOwnerId(materialOwnerId: self.ownerId)
        }
    }
    func isIAmOwner() -> Bool{
        let user = StoreUtil.getUser()!
        return user.id == self.ownerId
    }
    func getTask(id: String) -> Task!{
        let task = self.tasks.first { (t) -> Bool in
            return t.id == id
            } as! Task
        return task
    }
    func getTaskBy(code: String) -> Task?{
        let task = self.tasks.first { (t) -> Bool in
            return t.code == code
            }
        return task
    }
    func hasMyTasks() -> Bool {
        let user = StoreUtil.getUser()!
        let hasTasks =  self.tasks.flatMap({ (task) -> [Worker] in
            return task.workers
        }).contains { (worker) -> Bool in
            return worker.owner.id == user.id
        }
        return hasTasks
    }
    func getWorker(taskId: String, workerId: String) -> Worker? {
        guard let task = self.getTask(id: taskId) else {
            return nil
        }
        guard let worker = task.getWorker(id: workerId) else {
            return nil
        }
        return worker
    }
    func getActivities() -> [Activity] {
        let activities = self.tasks.flatMap { (task) -> [Activity] in
            return task.workers.flatMap({ (worker) -> [Activity] in
                return worker.activities
            })
        }
        return activities
        
    }
}
