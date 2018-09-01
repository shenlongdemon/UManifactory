//
//  History.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
class Activity: IObject, Mappable {
    var title: String = ""
    var description: String = ""
    var time: Int64 = 0
    var images:[String] = []
    var files:[String]? = []
    var logoTask: String!
    var worker: Worker!
    var coord : Coord!
    override init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.title     <- map["title"]
        self.description   <- map["description"]
        self.time   <- map["time"]
        self.images   <- map["images"]
        self.files   <- map["files"]
        
    }
}
class Weather: Mappable {
    var main: WeatherMain!
    var sys: WeatherSys!
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.main     <- map["main"]
        self.sys     <- map["sys"]
    }
}
class WeatherMain: Mappable {
    var temp: Double = 0
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.temp     <- map["temp"]
    }
}
class WeatherSys: Mappable {
    var country: String = ""
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.country     <- map["country"]
    }
}
class BLEPosition: Mappable {
    var coord: BLECoord!
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.coord     <- map["coord"]
    }
}
class Position: Mappable {
    var coord: Coord!
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.coord     <- map["coord"]
    }
    func toBLEPosition() -> BLEPosition{
        let blePosition = BLEPosition()
        let bleCcoord = BLECoord()
        bleCcoord.latitude = self.coord.latitude
        bleCcoord.longitude = self.coord.longitude
        bleCcoord.altitude = self.coord.altitude
        
        blePosition.coord = bleCcoord
        return blePosition
    }
}
class Coord: Mappable {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var altitude: Double = 0.0
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.latitude   <-  map["latitude"]
        self.longitude   <-  map["longitude"]
        self.altitude   <-  map["altitude"]       
       
    }
}
class BLECoord: Mappable {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var altitude: Double = 0.0
    var distance: Double = 0.0
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.latitude   <-  map["latitude"]
        self.longitude   <-  map["longitude"]
        self.altitude   <-  map["altitude"]
        self.distance   <-  map["distance"]

    }
}
