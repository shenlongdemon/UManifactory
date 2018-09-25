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
    var image: String = ""
    
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
    override init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name     <- map["name"]
        self.price   <- map["price"]
        self.category     <- map["category"]
        self.image   <- map["image"]
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
    }
    func getImage() -> UIImage? {
        return Util.getImage(data64: self.image)
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
        var str = "\(self.description)\n\n\(self.material?.getAllDescription() ?? "")"
        return str
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

