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
    var tasks : [Task] = []
    
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
        self.tasks   <- map["tasks"]
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
    
}
