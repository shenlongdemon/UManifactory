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
    var time: Int64
    var image: UIImage?
    var activity: Activity?
    init(location: Coord, name: String, time: Int64, image: UIImage?, activity: Activity?){
        self.location = location
        self.name = name
        self.time = time
        self.image = image
        self.activity = activity
    }
}
