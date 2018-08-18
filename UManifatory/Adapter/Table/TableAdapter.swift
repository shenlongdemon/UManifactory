//
//  TableView.swift
//  EasyParking
//
//  Created by test on 7/27/17.
//  Copyright © 2017 omidx. All rights reserved.
//

import UIKit

class TableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var items : NSMutableArray
    var cellIdentifier: String
    var cellHeight : CGFloat
    var cellCanEdit: Bool! = true
    private var didSelectRowAt : ((IObject) -> Void)? = nil
    private var didDeleteRowAt : ((IObject) -> Void)? = nil
    private var didPerformSelectRowAt : ((IObject, Int) -> Void)? = nil
    private var filterPredicate : ((Any) -> Bool)? = nil
    private var sortPredicate: ((Any, Any) -> ComparisonResult)? = nil
    
    
    public var allowDeleteRow: Bool = true
    
    init(items : NSMutableArray, cellIdentifier : String, cellHeight : CGFloat){
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.cellHeight = cellHeight
    }
    init(items : NSMutableArray, cellIdentifier : String, cellHeight : CGFloat, cellCanEdit: Bool){
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.cellHeight = cellHeight
        self.cellCanEdit = cellCanEdit
    }
    
    func filter(predicate: @escaping ((Any) -> Bool)) {
        self.filterPredicate = predicate
    }
    func sort(predicate: @escaping ((Any, Any) -> ComparisonResult)) {
        self.sortPredicate = predicate
        self.items.sort(usingComparator: sortPredicate!)
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        // Temp prevent edit
        
        if self.allowDeleteRow == false {
            
            if tableView.isEditing {
                return .delete
            }
            return .none
        }
        else { // True
            return .delete
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.clearsContextBeforeDrawing = true
        return items.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return cellCanEdit
    }
    func onDidSelectRowAt(handle : @escaping ((IObject) -> Void))  {
        self.didSelectRowAt = handle
    }
    func onDidPerformSelectRowAt(handle : @escaping ((IObject, Int) -> Void))  {
        self.didPerformSelectRowAt = handle
    }
    func onDidDeleteRowAt(handle : @escaping ((IObject) -> Void))  {
        self.didDeleteRowAt = handle
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! TableCell
        if self.isIndexPathValid(indexPath: indexPath) {
            let item = self.items[indexPath.row]
            cell.initData(object: item as! IObject)            
            cell.performSelect = self.didSelectRowAt
            cell.performSelectAt = self.didPerformSelectRowAt
            cell.isHidden = !(self.filterPredicate?(item as! IObject) ?? true)        
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if self.isIndexPathValid(indexPath: indexPath) {
            let item = self.items[indexPath.row]
            self.didDeleteRowAt?(item as! IObject)
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isIndexPathValid(indexPath: indexPath) {
            let item = self.items[indexPath.row]
            self.didSelectRowAt?(item as! IObject)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isIndexPathValid(indexPath: indexPath) {
            let item = self.items[indexPath.row]
            let height : CGFloat = (self.filterPredicate?(item as! IObject) ?? true) ? self.cellHeight : 0.0
            return height
        }
        else {
            return 0.0
        }
    }
    private func isIndexPathValid(indexPath: IndexPath) -> Bool{
        return self.items.count > 0 && indexPath.row < self.items.count
    }
    
    
}

