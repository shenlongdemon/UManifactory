//
//  Store.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/30/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

//
//  Util.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import UIKit
import QRCode
import Alamofire
import ObjectMapper
class StoreUtil {
   
    static func saveUser(user: User){
        let JSONString = user.toJSONString(prettyPrint: true)
        UserDefaults.standard.set(JSONString, forKey: "user")
    }
    static func savePosition(position: Position){
        let JSONString = position.toJSONString(prettyPrint: true)
        UserDefaults.standard.set(JSONString, forKey: "position")
    }
    
    static func getUser() -> User? {
        var user: User? = nil
        guard let json = UserDefaults.standard.object(forKey: "user") as? String else {
            return nil
        }
        user = json.cast()
        return user
    }
    static func getUserInfo() -> UserInfo? {
        var user: UserInfo? = nil
        guard let json = UserDefaults.standard.object(forKey: "user") as? String else {
            return nil
        }
        user = json.cast()
        return user
    }
    static func getPosition() -> Position? {
        var position: Position? = nil
        guard let json = UserDefaults.standard.object(forKey: "position") else {
            return nil
        }
        position = Mapper<Position>().map(JSONString: json as! String)
        return position
    }
    
}

