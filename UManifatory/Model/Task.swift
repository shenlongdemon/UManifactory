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
    var description: String = ""
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
        self.description     <- map["description"]
        self.image   <- map["image"]
        self.code   <- map["code"]
        self.materialId   <- map["materialId"]
        self.materialOwnerId   <- map["materialOwnerId"]
        self.workers   <- map["workers"]        
        for (_, worker) in self.workers.enumerated() {
            for (_, activity) in (worker.activities ?? []).enumerated() {
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
    func getActivities() -> [Activity] {
        let activities : [Activity] = self.workers.flatMap { (worker) -> [Activity] in
            return worker.activities ?? []
            } as [Activity]
        return activities;
    }
    func getLastActivity() -> Activity? {
        let activities = self.getActivities()
        let lastActivity : Activity? = activities.sorted { (a1, a2) -> Bool in
                return a1.time < a2.time
            }.first
        return lastActivity
    }
    func getStatus() -> Enums.TaskStatus{
        var status = Enums.TaskStatus.not_start
        let dones = self.workers.filter { (worker) -> Bool in
            return worker.status == Enums.TaskStatus.done
            }.count
        let startings = self.workers.filter { (worker) -> Bool in
            return worker.status == Enums.TaskStatus.starting
            }.count
        if self.workers.count == 0 {
            status = Enums.TaskStatus.not_start
        }
        else if dones == self.workers.count {
            status = Enums.TaskStatus.done
        }
        else if startings > 0 {
            status = Enums.TaskStatus.starting
        }
        return status
    }
    func getStatusPercent() -> Float {
        if self.workers.count == 0 {
            return 0.0;
        }
        let doneWorkers = self.workers.filter { (worker) -> Bool in
            return worker.status == Enums.TaskStatus.done
            }.count
        
        let startingWorkers = self.workers.filter { (worker) -> Bool in
            return worker.status == Enums.TaskStatus.starting
            }.count
        
        let percent = Float(Float(doneWorkers)  + (Float(startingWorkers) * 0.5)) / Float(self.workers.count) * 100.0
        return percent
    }
    func isGenCode() -> Bool {
        return self.id.hasPrefix("Gencode")
    }
    func isDone() -> Bool {
        if self.workers.count == 0 {
            return false;
        }
        return self.workers.filter { (worker) -> Bool in
            return worker.status == Enums.TaskStatus.done
            }.count == self.workers.count
    }
    func getActivityImageLinks() -> [String] {
        
        let images: [String] = self.getActivities().flatMap { (activity) -> [String] in
            return activity.images
        }
        return images
    }
    func getPDFFiles() -> [IObject] {
        let files: [IObject] = self.getActivities().flatMap { (activity) -> [IObject] in
            return activity.files?.map({ (f) -> IObject in
                let file: IObject = IObject()
                file.id = f
                return file
            }) ?? []
        }
        return files
    }
    func getActivityImages() -> [String] {
        return self.workers.flatMap({ (worker) -> [String] in
            return worker.getActivityImages()
        })        
    }
    func getActivityDescriptions() -> String{
        let descriptions = self.workers.flatMap { (worker) -> [String] in
            return (worker.activities ?? []).map({ (activity) -> String in
                return activity.description
            })
        }
        return descriptions.joined(separator: "\n")
    }
    func getAllDescription() -> String {
        let str = " - \(self.name)\n \(self.description)"
        return str
    }
    
}
