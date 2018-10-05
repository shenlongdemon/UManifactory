//
//  ItemHistory.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/26/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ItemHistory: IObject {
    var location: Coord
    var name: String
    var code: String
    var time: Int64
    var imageUrl: String?
    var activity: Activity?
    init(location: Coord, name: String, code: String, time: Int64, imageUrl: String?, activity: Activity?){
        self.location = location
        self.name = name
        self.code = code
        self.time = time
        self.imageUrl = imageUrl
        self.activity = activity
    }
    func getImage(completion: @escaping (_ img: UIImage?)->Void){
        AppUtil.getImage(imageName: self.imageUrl ?? "") { (img) in
            completion(img)
        }
    }
}
