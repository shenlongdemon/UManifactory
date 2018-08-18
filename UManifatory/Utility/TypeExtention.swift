//
//  TypeExtention.swift
//  ParkingExChangeClaim
//
//  Created by test on 8/21/17.
//  Copyright © 2017 omidx. All rights reserved.
//

import UIKit
import ObjectMapper
class TypeExtention {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
extension Float{
    func meterToMile() -> Float {
        return self * 0.000621371
    }
    
    
}

extension Date{
    static func from(year : Int, month : Int, day : Int, hour : Int, minute: Int, second : Int) -> Date {
        
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }
    func get(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    func intervalSince1970() -> Int{
        let now = Int(self.timeIntervalSince1970)
        return now
    }
    func toTime12h() -> String {
        let ampm = self.get(.hour) > 12 ? "PM" : "AM"
        let hour = self.get(.hour) > 12 ? self.get(.hour) - 12 : self.get(.hour)
        let minute = self.get(.minute)
        let minStr = minute < 10 ? "0\(minute)" : "\(minute)"
        let text = "\(hour):\(minStr) \(ampm)"
        return text
    }
    func toDateTimeStr() -> String {
        let formatter = DateFormatter()
        
        //formatter.dateFormat = "dd.MM.yyyy"
        formatter.dateFormat = "MMM dd, yyyy"
        let result = formatter.string(from: self)
        
        let str = "\(result) \(self.toTime12h())"
        return str
        
    }
}
extension AnyHashable {
    func cast<T: BaseMappable>() -> T? {
        do{
            
            if let stringConvert = self.base as? String{
                let user = Mapper<T>().map(JSONString: stringConvert)
                return user
            }
        }
        catch{
            return nil
        }
        return nil
    }
}
extension String {
    func cast<T: BaseMappable>() -> T? {
        var t : T? = nil
        let data = self.data(using: String.Encoding.utf8)
        do {
            let dictonary:NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] as! NSDictionary
            
            if let myDictionary = dictonary
            {
                t = myDictionary.cast()!
            }
        } catch let error as NSError {
            print(error)
        }
        return t
    }
}
extension NSDictionary {
    func cast<T: BaseMappable>() -> T? {
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            let stringConvert = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            let user = Mapper<T>().map(JSONString: stringConvert)
            return user
        }
        catch{
            return nil
        }
    }
    func getInt(key: String) -> Int {
        if self[key] is String {
            let val : Int = Int(self[key] as! String)!
            return val
        }
        else {
            let val : Int = (self[key] as! Int)
            return val
        }
        
    }
    func getFloat(key: String) -> Float {
        if self[key] is String {
            let val : Float = Float(self[key] as! String)!
            return val
        }
        else {
            let val : Float = (self[key] as! Float)
            return val
        }
    }
    func getObject<T: BaseMappable>(key : String) -> T? {
        
        if self[key] is String {
            do {
                let str = self[key] as! String
                let user = try Mapper<T>().map(JSONString: str)
                return user
            }
            catch{
                return nil
            }
        }
        else if self[key] is NSDictionary{
            let dic = self[key] as! NSDictionary
            let user : T? = dic.cast()
            return user
        }
        return nil
    }
}
extension UIViewController {
    func addRootBackButton(action: Selector) {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: action)
        
        backButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.leftBarButtonItem = backButton
    }
}
extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}




extension NSObject{
    func toDic() -> NSDictionary {
        let dict:NSMutableDictionary = NSMutableDictionary()
        var counts = UInt32();
        let properties = class_copyPropertyList(self.classForCoder, &counts);
        for i in 0..<counts {
            let property = properties?.advanced(by: Int(i)).pointee;
           
            let cName = property_getName(property!);
            
            let prop = String(cString: cName)
            let cAttr = property_getAttributes(property!)!
            let attr = String(cString:cAttr)
           
            self.add(dict: dict, prop: prop, objAny: self, type: attr)
        }
        return dict;
    }
    private func add(dict: NSMutableDictionary, prop: String, objAny: Any, type: String) {
        if let obj = objAny as? AnyObject {
            if let val = obj.value(forKey: prop) as? String {
                dict.setValue(val, forKey: prop)
            } else if let val = obj.value(forKey: prop) as? Int {
                dict.setValue(val, forKey: prop)
            } else if let val = obj.value(forKey: prop) as? Double {
                dict.setValue(val, forKey: prop)
            }
            else if let val = obj.value(forKey: prop) as? Array<Any> {
                dict.setValue(val, forKey: prop)
            }
            else if let val = obj.value(forKey: prop) as? Array<AnyObject> {
                dict.setValue(val, forKey: prop)
            }
            else if let val = obj.value(forKey: prop) as? Array<String> {
                dict.setValue(val, forKey: prop)
            } else if let val = obj.value(forKey: prop) as? Int64 {
                dict.setValue(val, forKey: prop)
            } else if let val = obj.value(forKey: prop) as? Array<Dictionary<String,Any>> {
                dict.setValue(val, forKey: prop)
               
            } else if let val = obj.value(forKey: prop) as? Array<Dictionary<String,AnyObject>> {
                dict.setValue(val, forKey: prop)
                
            } else if let val = obj.value(forKey: prop) as? Dictionary<String,AnyObject> {
                dict.setValue(val, forKey: prop)
                
            } else if let val = obj.value(forKey: prop) as? Dictionary<String,Any> {
                dict.setValue(val, forKey: prop)
                
            } else if obj.value(forKey: prop) is Array<Any> {
                let arr = obj.value(forKey: prop)  as! Array<Any>
            }
            else if let val = obj.value(forKey: prop) as? AnyObject {
                
                
            } else if let val = obj.value(forKey: prop) as? Any {
                 dict.setValue(val, forKey: prop)
            } else if let val = obj.value(forKey: prop) as? NSObject{
                let d = val.toDic()
                dict.setValue(d, forKey: prop)
            }
        }
        else {
            dict.setValue(objAny, forKey: prop)
        }
    }
}
