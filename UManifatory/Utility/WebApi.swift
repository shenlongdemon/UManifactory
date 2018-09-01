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
    static let HOST = "http://192.168.1.5:5000"
     static let GET_CATEGORIES = "\(WebApi.HOST)/api/sellrecognizer/getCategories"
    static let GET_MATERIAL_BY_ID = "\(WebApi.HOST)/api/manifactory/getMaterialById?id={id}"
    static let GET_USER_BY_ID = "\(WebApi.HOST)/api/manifactory/getUserById?id={id}"
    
    static let GET_MATERIALS_BY_BLUETOOTH_UUIDS = "\(WebApi.HOST)/api/manifactory/getProjectsByBluetoothUUIDs"
    static let GET_MATERIALS_BY_OWNERID = "\(WebApi.HOST)/api/manifactory/getMaterialsByOwnerId?id={id}&pageSize={pageSize}&pageNum={pageNum}"
    static let LOGIN = "\(WebApi.HOST)/api/manifactory/login"
    static let ASSIGN_WORKER_TO_TASK = "\(WebApi.HOST)/api/manifactory/assignWorkerToTask"
    static let SAVE_ACTIVITY = "\(WebApi.HOST)/api/manifactory/saveActivity"
    static let UPLOAD_ACTIVITY_IMAGE = "\(WebApi.HOST)/api/upload/manifactory/activity?id={id}"
    static let UPLOAD_ACTIVITY_FILE = "\(WebApi.HOST)/api/upload/manifactory/activity?id={id}"
    static let GET_MATERIAL_BY_QRCODE = "\(WebApi.HOST)/api/manifactory/getMaterialByQRCode"
    static let CREATE_MATERIAL = "\(WebApi.HOST)/api/manifactory/createMaterial"
    static let CREATE_TASK = "\(WebApi.HOST)/api/manifactory/createTask"
    static let GET_MATERIALS_BY_BLUETOOTHS = "\(WebApi.HOST)/api/manifactory/getMaterialsByBluetooths"
    static let GET_ITEMS_BY_USERID = "\(WebApi.HOST)/api/sellrecognizer/getItemsByOwnerId?ownerId={userId}&pageNum=1&pageSize=10000"
    static let ADD_ITEM = "\(WebApi.HOST)/api/sellrecognizer/insertItem"
    static func manager()-> SessionManager{
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.session.configuration.httpAdditionalHeaders?.updateValue("application/json", forKey: "Accept")
        manager.session.configuration.httpAdditionalHeaders?.updateValue("application/json", forKey: "Content-Type")
        return manager
    }
    static func getItemsByOwnerId(userId: String, completion: @escaping (_ list:[Item])->Void){
        let url = URL(string: WebApi.GET_ITEMS_BY_USERID.replacingOccurrences(of: "{userId}", with: userId))
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let arr = apiModel.Data as! [Any]
                    var items : [Item] = []
                    for jsonItem in arr{
                        let strJSON = jsonItem as! NSDictionary
                        let item : Item = strJSON.cast()!
                        items.append(item)
                    }
                    completion(items)
                }
                else {
                    completion([])
                }
                
        }
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
    static func getUserById(id: String, completion: @escaping (_ user: User?)->Void){
        let url = URL(string: WebApi.GET_USER_BY_ID.replacingOccurrences(of: "{id}", with: id))
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                if(apiModel.Status == 1){
                    let item: User? = Mapper<User>().map(JSONObject: apiModel.Data)
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
    static func saveActivity(_ materialId: String, _ taskId: String!, _ workerId: String, _ title: String, _ description: String, _ imageNames: [String],_ fileNames: [String],_ userInfo: UserInfo,completion: @escaping (_ done: Bool )->Void){
        let parameters: Parameters = [
            "materialId": materialId,
            "taskId": taskId,
            "workerId": workerId,
            "title": title,
            "description": description,
            "imageNames": imageNames,
            "fileNames":fileNames,
            "userInfo" : userInfo.toJSON()
            
        ]
        let url = URL(string: WebApi.SAVE_ACTIVITY)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(false)
                    return
                }
                completion(apiModel.Status == 1)                
        }
    }
    static func uploadActivityImages(taskId: String, images: [UIImage], names: [String],completion: @escaping (_ done: Bool )->Void){
    
        let url = WebApi.UPLOAD_ACTIVITY_IMAGE.replacingOccurrences(of: "{id}", with: taskId)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (index, _) in images.enumerated() {
                let imgData = UIImageJPEGRepresentation(images[index], 0.2)
                let name = names[index]
                multipartFormData.append(imgData!, withName: "imgUploader",fileName: name, mimeType: "image/jpg")
                
            }
        }, to: url) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    completion(true)
                }
                
            case .failure(let encodingError):
                completion(false)
            }
        }
    }
    static func uploadActivityFiles(taskId: String, fileUrls: [URL], names: [String],completion: @escaping (_ done: Bool )->Void){
        
        let url = WebApi.UPLOAD_ACTIVITY_FILE.replacingOccurrences(of: "{id}", with: taskId)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (index, url) in fileUrls.enumerated() {
                //let pdfData = try! Data(contentsOf: url)
                let data = try? Data(contentsOf: url)
                if let d = data {
                    multipartFormData.append(d, withName: "imgUploader", fileName: names[index], mimeType:"application/pdf")
                }
                
            }
        }, to: url) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    completion(true)
                }
                
            case .failure(let encodingError):
                completion(false)
            }
        }
    }
    static func getMaterialByQRCode(qrcode: String, completion: @escaping (_ material: Material? )->Void){
        let parameters: Parameters = [
            "qrcode": qrcode
        ]
        let url = URL(string: WebApi.GET_MATERIAL_BY_QRCODE)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
    static func createMaterial(ownerId: String, title: String, description: String, image: String, bluetooth: BLEDevice?, userInfo: UserInfo, completion: @escaping (_ material: Material? )->Void){
        let parameters: Parameters = [
            "ownerId": ownerId,
            "name": title,
            "description": description,
            "image": image,
            "bluetooth": bluetooth?.id ?? "",
            "userInfo" : userInfo.toJSON()
        ]
        let url = URL(string: WebApi.CREATE_MATERIAL)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
    static func createTask(materialId: String, title: String, description: String, image: String, userInfo: UserInfo, completion: @escaping (_ task: Task? )->Void){
        let parameters: Parameters = [
            "materialId": materialId,
            "name": title,
            "description": description,
            "image": image,
            "userInfo" : userInfo.toJSON()
        ]
        let url = URL(string: WebApi.CREATE_TASK)
        
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let item: Task? = Mapper<Task>().map(JSONObject: apiModel.Data)
                    completion(item)
                }
                else {
                    completion(nil)
                }
        }
    }
    static func getMaterialsByBluetooths(bluetooths: [BLEDevice], coord: Coord,myId: String, completion: @escaping (_ materials: [Material] )->Void){
        let parameters: Parameters = [
            "bluetooths": bluetooths.toJSON(),
            "coord": coord.toJSON(),
            "myId" : myId
        ]
        let url = URL(string: WebApi.GET_MATERIALS_BY_BLUETOOTHS)
        WebApi.manager().request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
    static func getCategories(completion: @escaping (_ list:[Category])->Void){
        
        let url = URL(string: WebApi.GET_CATEGORIES)
        
        WebApi.manager().request(url!)
            .responseJSON { (data) in
                
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion([])
                    return
                }
                
                if(apiModel.Status == 1){
                    let items : [Category] = Mapper<Category>().mapArray(JSONObject:apiModel.Data) ?? []
                    completion(items)
                }
                else {
                    completion([])
                }
                
        }
    }
    static func addItem(item: Item, completion: @escaping (_ item: Item? )->Void){
        let json = item.toJSON()
        let url = URL(string: WebApi.ADD_ITEM)
        
        WebApi.manager().request(url!, method: .post, parameters: json, encoding: JSONEncoding.default)
            .responseJSON { (data) in
                guard let apiModel = Mapper<ApiModel>().map(JSONObject:data.result.value) else {
                    completion(nil)
                    return
                }
                
                if(apiModel.Status == 1){
                    let item: Item? = Mapper<Item>().map(JSONObject: apiModel.Data)
                    completion(item)
                }
                else {
                    completion(nil)
                }
                
                
        }
    }
    
}

