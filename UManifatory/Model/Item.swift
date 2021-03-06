//
//  Item.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class Item: IObject, Mappable {
    var name: String = ""
    var price: String = ""
    var description: String = ""
    var category: Category!
    var imageUrl: String = ""
    
    var code: String = ""
    var sellCode: String = ""
    var buyerCode: String = ""
    var bluetoothCode: String = ""
    var section: Section!
    var owner: UserInfo!
    var buyer: UserInfo?
    var iBeacon: BLEDevice?
    var location: BLEPosition!
    var bluetooth : Bluetooth?
    var view3d : String = ""
    var material: Material? = nil
    var time: Int64 = Util.getCurrentMillis()
    var maintains: [Activity] = []
    override init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name     <- map["name"]
        self.price   <- map["price"]
        self.category     <- map["category"]
        self.imageUrl   <- map["imageUrl"]
        self.description     <- map["description"]
        self.code     <- map["code"]
        self.sellCode   <- map["sellCode"]
        self.buyerCode     <- map["buyerCode"]
        self.bluetoothCode   <- map["bluetoothCode"]
        self.section   <- map["section"]
        self.owner   <- map["owner"]
        self.buyer   <- map["buyer"]
        self.location   <- map["location"]
        self.bluetooth   <- map["bluetooth"]
        self.view3d   <- map["view3d"]
        self.material   <- map["material"]
        self.iBeacon   <- map["iBeacon"]
        self.time   <- map["time"]
        self.maintains   <- map["maintains"]
    }
    func getImage(completion: @escaping (_ img: UIImage?)->Void){
        AppUtil.getImage(imageName: self.imageUrl) { (img) in
            completion(img)
        }
    }
    func getProductCode() -> String {
        var code = ""
        if self.buyerCode.count > 0 {
            code = self.buyerCode
        }
        else if self.sellCode.count > 0 {
            code = self.sellCode
        }
        else {
            code = self.code
        }
       return code
    }
    func getAllDescription() -> String {
        let str = "\(self.name)\n\n\(self.description)\n\n\(self.material?.getAllDescription() ?? "")"
        return str
    }
    func isPublish() -> Bool{
        return self.sellCode != ""
    }
}
class Section: Mappable {
    var code : String = ""
    var history: [UserInfo] = []
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.code <- map["code"]
        self.history <- map["history"]
    }
}

