//
//  AppUtil.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/19/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//


import Foundation
import UIKit
import QRCode
import Alamofire
import ObjectMapper
import ImageSlideshow
class AppUtil {
    static func getInputSources(item: Item) -> [InputSource] {
        var inputSources : [InputSource] = []
        if let itemImg = item.getImage() {
            inputSources.append(ImageSource(image: itemImg))
        }
        
        if let material = item.material {
            if let imgMat = material.getImage() {
                inputSources.append(ImageSource(image: imgMat))
            }
            
            for (_, imageName) in material.getActivityImages().enumerated() {
                let urlString = "\(WebApi.HOST)/uploads/\(imageName)"
                let a = AlamofireSource(urlString: urlString)
                inputSources.append(a!)
            }
        }       
        
        return inputSources
    }
}
