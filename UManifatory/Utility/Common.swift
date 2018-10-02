//
//  Common.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/15/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import Foundation
class Segue {
    static let to_main = "to_main"
    static let main_to_bluetooth = "main_to_bluetooth"
    static let main_to_material = "main_to_material"
    static let main_to_activity = "main_to_activity"
    static let main_to_mymaterial = "main_to_mymaterial"
    static let bluetooth_to_material = "bluetooth_to_material"
    static let list_to_project = "list_to_project"
    
    static let material_to_admintask = "material_to_admintask"
    static let material_to_task = "material_to_task"
    static let material_to_assignworker = "material_to_assignworker"
    
    static let assignworker_to_activity = "assignworker_to_activity"
    
    static let to_create_material = "to_create_material"
    static let creatematerial_to_bluetooth = "creatematerial_to_bluetooth"
    static let to_create_task = "to_create_task"
    static let additem_to_bluetooth = "additem_to_bluetooth"
    static let main_to_items = "main_to_items"
    static let add_item = "add_item"
    static let additem_to_bluetoottmaterial = "additem_to_bluetoottmaterial"
    static let material_to_detail = "material_to_detail"
    static let main_to_profile = "main_to_profile"
    static let main_scan_to_product = "main_scan_to_product"
    static let activity_to_detail = "activity_to_detail"
    static let materialdetail_to_activitydetail = "materialdetail_to_activitydetail"
    static let material_to_taskdetail = "material_to_taskdetail"
    static let task_to_gencode = "task_to_gencode"
    static let goods_to_detail = "goods_to_detail"
    static let main_to_bluetoothproduct_around = "main_to_bluetoothproduct_around"
    static let material_detail_to_add_activity = "material_detail_to_add_activity"
    static let bluetooth_around_to_product = "bluetooth_around_to_product"
    static let itemhistory_to_activitydetail = "itemhistory_to_activitydetail"
    static let main_to_search = "main_to_search"
    static let search_to_product = "search_to_product"
    static let productsearch_to_detail = "productsearch_to_detail"
    static let itemdetail_to_payment = "itemdetail_to_payment"
}

class Constant {
    static let Hour_Format = "HH : mm a"
    static let Date_Format = "yyyy/MM/dd"
}
class Enums {
    enum TaskStatus : Int  {
        case not_start = 0,
        starting, done
        // Một hằng số tĩnh chứa tất cả các phần tử của enum Month.
        static let allValues = [not_start, starting, done]
        
    }
    enum SearchProductTypes : Int  {
        case in_app = 0,
        on_web
        // Một hằng số tĩnh chứa tất cả các phần tử của enum Month.
        static let allValues = [in_app, on_web]
        
    }
    enum ScanQRItemType : Int {
        case unknown = 0,
        material,
        product
        static let allValues = [unknown, material, product]
    }
    enum ItemHistoryType : Int {
        case no_data = 0,
        has_data
        static let allValues = [no_data, has_data]
    }
    enum ItemActionType : Int {
        case no = 0,
        sell,
        buy,
        confirm_buy,
        cancel_sell
        static let allValues = [no, sell, buy, confirm_buy, cancel_sell]
    }
}


