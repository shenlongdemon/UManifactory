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
        let itemImageUrl = "\(WebApi.HOST)/uploads/\(item.imageUrl)"
        let itemImageA = AlamofireSource(urlString: itemImageUrl)
        inputSources.append(itemImageA!)
        
        
        
        if let material = item.material {
            let matImageUrl = "\(WebApi.HOST)/uploads/\(item.imageUrl)"
            let matImageA = AlamofireSource(urlString: itemImageUrl)
            inputSources.append(matImageA!)
                       
            for (_, imageName) in material.getActivityImages().enumerated() {
                let urlString = "\(WebApi.HOST)/uploads/\(imageName)"
                let a = AlamofireSource(urlString: urlString)
                inputSources.append(a!)
            }
        }
        
        return inputSources
    }
    static func getImage(imageName : String, completion: @escaping (_ image:UIImage?)->Void){
        if imageName == ""{
            completion(nil)
        }
        else {
            DispatchQueue.global().async {
                let urlString = "\(WebApi.HOST)/uploads/\(imageName)"
                let u = URL(string:  urlString)
                let data = try? Data(contentsOf: u!)
                if let d = data {
                    DispatchQueue.main.async { () -> Void in
                        
                        completion(UIImage(data: d))
                    }
                }
                else {
                    completion(nil)
                }
            }
        }
    }
}
