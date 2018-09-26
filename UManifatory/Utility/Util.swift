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
import CoreBluetooth
import CoreLocation
class Util {
    
    static func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    static func getDistance(beacon: CLBeacon, currentPosition: Position?) -> Float{
        var distance : Float = -1.0
        guard let pos = currentPosition else {
            return distance
        }
        distance = abs(Float(beacon.accuracy) - 0.5)
        return distance
    }
//    static func CLProximity2Int(proximity:CLProximity) -> Int {
//        switch proximity {
//        case .unknown:
//            return -1
//        case .far:
//            return 1
//        case .near:
//            return 5
//        case .immediate:
//            return 20
//        default:
//            return -1 // Also handles .Unknown case
//        }
//    }

    static func getDate(milisecond: Int64, format: String) -> String{
        if (milisecond == 0) {
            return ""
        }
        let dateVar = Date(timeIntervalSince1970: TimeInterval(milisecond) / 1000)        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return (dateFormatter.string(from: dateVar))
    }
    
    static let transformDouble = TransformOf<Double, String>(fromJSON: { (value: String?) -> Double? in
        // transform value from String? to Int?
        if let v = value {
            return Double(v)
        }
        else {
            return nil
        }
    }, toJSON: { (value: Double?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    static func getImage(data64: String) -> UIImage? {
        var uiimage:UIImage? = nil
        if (data64 != ""){
            let dataDecoded : Data = Data(base64Encoded: data64, options: .ignoreUnknownCharacters)!
            uiimage = UIImage(data: dataDecoded)
        }
        return uiimage
    }
    static func getQRCodeImage(str: String) -> UIImage?{
        var image : UIImage? = nil
        do{
            let qrCode = QRCode(str)
            image = qrCode?.image
        }
        catch _{
        
        }
        return image
    }
    static func showYesNoAlert(VC:UIViewController,  message:String?, yesHandle: @escaping (_ action:Void)->Void, noHandle: @escaping (_ action:Void)->Void){
        
            let alert = UIAlertController(title: "Dassee", message: message ?? "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in
                yesHandle(())
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: {(alert: UIAlertAction!) in
                
            }))
            VC.present(alert, animated: true, completion: nil)
        
    }
    static func showOKAlert(VC:UIViewController,  message:String?)-> Void {
        let alert = UIAlertController(title: "Dassee", message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        VC.present(alert, animated: true, completion: nil)
    }
    static func getTopViewController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        else {
            return nil
        }
    }
    static func showAlert(message:String?)-> Void {
        if let topController = Util.getTopViewController() {
            let alert = UIAlertController(title: "Dassee", message: message ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            topController.present(alert, animated: true, completion: nil)
            // topController should now be your topmost view controller
        }
    }
    static func showAlert(message:String?, okHandle: @escaping ()->Void){
        if let topController = Util.getTopViewController() {
            let alert = UIAlertController(title: "Dassee", message: message ?? "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
                okHandle()
            }))
            topController.present(alert, animated: true, completion: nil)
        }
        
    }
    static func showModal(modalVC: UIViewController) {
        if let currentVC = getVC() {
            modalVC.modalPresentationStyle = .overCurrentContext
            currentVC.present(modalVC, animated: true, completion: nil)
        }
        
    }
    static func getVC() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
           return topController
        // topController should now be your topmost view controller
        }
        else {
            return nil
        }
    }
        
    
    static func resizeImage(image : UIImage) -> UIImage{
       
        let v : CGFloat = 300.0
        let w = image.size.width
        let h = image.size.height
        
        let ratio = v / h
        
        let nh = v
        let nw = w * ratio
        
        let newSize: CGSize = CGSize(width: nw, height: nh)
       
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: nw, height: nh)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    static func getData64(image: UIImage?) -> String{
        guard let img = image else {
            return ""
        }
        let imageData:NSData = UIImagePNGRepresentation(img)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    static func getAppDelegate() -> AppDelegate? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate;
    }
    static func getUesrInfo(completion: @escaping (_ usrInfo: UserInfo? )->Void){
        var userInfo : UserInfo = StoreUtil.getUserInfo()!
        userInfo.position = StoreUtil.getPosition()!
        WebApi.getWeather(lat: userInfo.position.coord.latitude, lon: userInfo.position.coord.longitude) { (weather) in
            if let wa = weather {
                userInfo.weather = wa
                let nowDoublevaluseis = NSDate().timeIntervalSince1970
                userInfo.time = Int64(nowDoublevaluseis*1000)
                completion(userInfo)
            }
            else {
                Util.showAlert(message: "Cannot get weather.")
                completion(nil)
            }
        }
    }

    static func drawOMIDCode(strCode : String) -> UIImage{
        let str = strCode.lowercased()
//        let a = "____-__0__1__2__3__4__5__6__7__8__9__a__b__c__d__e__f__g__h__i__j__k__l__m__n__o__p__q__r__s__t__u__v__w__x__y__z";
//        let chacs = "abcdefghijklmnopqrstuvwxyz"
//        let numbers = "0123456789"
        let STR = "____abcdefghijklmnopqrstuvwxyz-0123456789_____";
        let size = 500
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        
        // draw circle outside
        ctx.setLineWidth(5.0)
        ctx.setStrokeColor(UIColor.blue.cgColor)
        let circleOutsideRect = CGRect(x: 0,y: 0,width: size - 10,height: size - 10)
        ctx.addEllipse(in: circleOutsideRect)
        ctx.strokePath()
        
        // draw circle inside
        let circleRadiusInside = 50
        ctx.setLineWidth(5.0)
        ctx.setStrokeColor(UIColor.blue.cgColor)
        let circleInsideRect = CGRect(x: size/2-circleRadiusInside,y: size/2-circleRadiusInside,width: circleRadiusInside * 2,height: circleRadiusInside * 2)
        ctx.addEllipse(in: circleInsideRect)
        ctx.strokePath()
        // draw all lines
        let ang : CGFloat = 360.0 / CGFloat(str.count)
        let ratio = (size - circleRadiusInside) / 2 / STR.count
        var i : CGFloat = 0.0
        let smallCircleRadius : CGFloat = 3.0
        let blue = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        for ch in str{
            let index = STR.index(of: ch)?.encodedOffset as! Int
            let center = CGPoint(x: size / 2, y: size / 2 )
            let pathIn = UIBezierPath(arcCenter: center, radius: CGFloat(circleRadiusInside), startAngle: (ang * i), endAngle:(ang * i), clockwise: true)
            let inPoint = pathIn.currentPoint
            
            let pathout = UIBezierPath(arcCenter: center, radius: CGFloat(circleRadiusInside + index * ratio), startAngle: (ang * i), endAngle:(ang * i), clockwise: true)
            let outPoint = pathout.currentPoint
            // draw line
            ctx.setLineWidth(1.0)
            ctx.setStrokeColor(UIColor.red.cgColor)
            ctx.move(to: inPoint)
            ctx.addLine(to: outPoint)
            ctx.strokePath()
            // draw small circle
            
            
            let circleInsideRect = CGRect(x: (outPoint.x - smallCircleRadius) ,y: (outPoint.y - smallCircleRadius), width: smallCircleRadius * 2,height: smallCircleRadius * 2)
            
            ctx.setLineWidth(1.0)
            ctx.setStrokeColor(blue.cgColor)
            ctx.setFillColor(blue.cgColor)
            ctx.fillEllipse(in: circleInsideRect)
            
            i += 1.0
        }
        
        
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    static func getBLEBeaconDistance(RSSI: NSNumber) -> Double {
        let rssi : Double = RSSI.doubleValue
        if (rssi == 0) {
            return -1.0; // if we cannot determine accuracy, return -1.
        }
        
        let ratio: Double = rssi * 1.0 / (-60.0);
        if (ratio < 1.0) {
            return pow(ratio,10);
        }
        else {
            let accuracy : Double =  (0.89976) * pow(ratio,7.7095) + 0.111;
            return accuracy;
        }
    }
    static func print(id: String, image: UIImage, frame: CGRect, inView: UIView) {
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = .general
        printInfo.jobName = "\(id)"
        
        // Set up print controller
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        // Assign a UIImage version of my UIView as a printing iten
        printController.printingItem = image
        
        // Do it
        printController.present(from: frame, in: inView, animated: true, completionHandler: nil)
        // Do any additional setup after loading the view.
    }
}
