//
//  File.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

//
//  WebApi.swift
//  ugutaDID
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
class WebApi{
    //static let HOST = "http://96.93.123.233:5000"
    static let HOST = "http://192.168.1.15:5000"
    //static let HOST = "http://192.168.79.84:5000"
    //static let HOST = "http://192.168.60.67:5000" // wifi
    static let GET_MATERIAL_BY_ID = "\(WebApi.HOST)/api/manifactory/getMaterialById?id={id}"
    static let GET_MATERIALS_BY_BLUETOOTH_UUIDS = "\(WebApi.HOST)/api/manifactory/getProjectsByBluetoothUUIDs"
    static let GET_MATERIALS_BY_OWNERID = "\(WebApi.HOST)/api/manifactory/getMaterialsByOwnerId?id={id}&pageSize={pageSize}&pageNum={pageNum}"
    static let LOGIN = "\(WebApi.HOST)/api/manifactory/login"
    static let ASSIGN_WORKER_TO_TASK = "\(WebApi.HOST)/api/manifactory/assignWorkerToTask"
    static func manager()-> SessionManager{
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.session.configuration.httpAdditionalHeaders?.updateValue("application/json", forKey: "Accept")
        manager.session.configuration.httpAdditionalHeaders?.updateValue("application/json", forKey: "Content-Type")
        return manager
    }
    static func getWeather(lat: Double, lon: Double, completion: @escaping (_ weather:Weather?)->Void){
        let str =   "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&APPID=6435508fad5982cda8c0a812d7a57860&units=metric"
        let url = URL(string: str)
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                let weather = Mapper<Weather>().map(JSONObject: data.result.value)
                if let wea = weather {
                    completion(wea)
                }
                else {
                    let str = "{\n    \"coord\": {\n        \"lon\": 108.2,\n        \"lat\": 16.07\n    },\n    \"weather\": [\n        {\n            \"id\": 801,\n            \"main\": \"Clouds\",\n            \"description\": \"few clouds\",\n            \"icon\": \"02d\"\n        }\n    ],\n    \"base\": \"stations\",\n    \"main\": {\n        \"temp\": 34.37,\n        \"pressure\": 1007,\n        \"humidity\": 66,\n        \"temp_min\": 32,\n        \"temp_max\": 36\n    },\n    \"visibility\": 8000,\n    \"wind\": {\n        \"speed\": 5.1,\n        \"deg\": 110\n    },\n    \"clouds\": {\n        \"all\": 20\n    },\n    \"dt\": 1526367600,\n    \"sys\": {\n        \"type\": 1,\n        \"id\": 7978,\n        \"message\": 0.0112,\n        \"country\": \"VN\",\n        \"sunrise\": 1526336236,\n        \"sunset\": 1526382600\n    },\n    \"id\": 1583992,\n    \"name\": \"Turan\",\n    \"cod\": 200\n}"
                    let w = Mapper<Weather>().map(JSONString: str)
                     completion(w)
                }
                
        }
    }
    
    static func getImage(url : String, completion: @escaping (_ image:UIImage?)->Void){
        if url == ""{
            completion(nil)
        }
        else {
            DispatchQueue.global().async {
                let u = URL(string:  url)
                let data = try? Data(contentsOf: u!)
                DispatchQueue.main.async { () -> Void in
                    
                    completion(UIImage(data: data!))
                }
            }
        }
    }
    static func getMaterialById(id: String, completion: @escaping (_ item: Material?)->Void){
        let url = URL(string: WebApi.GET_MATERIAL_BY_ID.replacingOccurrences(of: "{id}", with: id))
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }                
                if(apiModel.Status == 1){
                    let item: Material? = Mapper<Material>().map(JSONObject: apiModel.Data)
                    completion(item)
                }
                else {
                    completion(nil)
                }
        }
    }
    static func getMaterialsByOwnerId(ownerId : String, pageSize: Int, pageNum: Int, completion: @escaping (_ projects: [Material])->Void){
        
        let url = URL(string: WebApi.GET_MATERIALS_BY_OWNERID.replacingOccurrences(of: "{id}", with: ownerId).replacingOccurrences(of: "{pageSize}", with: "\(pageSize)").replacingOccurrences(of: "{pageNum}", with: "\(pageNum)"))
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion([])
                    return
                }
                if(apiModel.Status == 1){
                    let items : [Material] = Mapper<Material>().mapArray(JSONObject:apiModel.Data) ?? []
                    completion(items)
                }
                else {
                    completion([])
                }
        }
    }
    static func login(phone: String, password: String,completion: @escaping (_ user: User? )->Void){
        
        let parameters: Parameters = [
            "phone": phone,
            "password": password
        ]
        let url = URL(string: WebApi.LOGIN)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let dic = apiModel.Data as! NSDictionary
                    let user : User = dic.cast()!
                    completion(user)
                }
                else {
                    completion(nil)
                }
                
        }
    }
    static func assignWorkerToTask(materialId: String, taskId: String, workerId: String,completion: @escaping (_ worker: Worker? )->Void){
        let parameters: Parameters = [
            "materialId": materialId,
            "taskId": taskId,
            "workerId": workerId
        ]
        let url = URL(string: WebApi.ASSIGN_WORKER_TO_TASK)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let dic = apiModel.Data as! NSDictionary
                    let worker : Worker = dic.cast()!
                    completion(worker)
                }
                else {
                    completion(nil)
                }
                
        }
    }
}

