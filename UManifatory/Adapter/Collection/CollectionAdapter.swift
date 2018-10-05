//
//  CollectionAdapter.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/18/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class CollectionAdapter: NSObject,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var items : NSMutableArray
    var cellIdentifier: String
    var cellHeight : CGFloat
    var itemPerRow : CGFloat
    private var didSelectRowAt : ((IObject) -> Void)? = nil
    private var didPerformSelectRowAt : ((IObject, Int) -> Void)? = nil
    private var filterPredicate : ((Any) -> Bool)? = nil
    private var sortPredicate: ((Any, Any) -> ComparisonResult)? = nil
    
    
    
    init(items : NSMutableArray, cellIdentifier : String, itemPerRow: Int, cellHeight : CGFloat){
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.itemPerRow = CGFloat(itemPerRow)
        self.cellHeight = cellHeight
    }
    
    func onDidSelectRowAt(handle : @escaping ((IObject) -> Void))  {
        self.didSelectRowAt = handle
    }
    func onDidPerformSelectRowAt(handle : @escaping ((IObject, Int) -> Void))  {
        self.didPerformSelectRowAt = handle
    }
    
    func filter(predicate: @escaping ((Any) -> Bool)) {
        self.filterPredicate = predicate
    }
    func sort(predicate: @escaping ((Any, Any) -> ComparisonResult)) {
        self.sortPredicate = predicate
        self.items.sort(usingComparator: sortPredicate!)
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isIndexPathValid(indexPath: indexPath) {
            let item = self.items[indexPath.row]
            self.didSelectRowAt?(item as! IObject)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! CollectionCell
        if self.isIndexPathValid(indexPath: indexPath) {
            let item = self.items[indexPath.row]
            cell.initData(object: item as! IObject)
            cell.performSelect = self.didSelectRowAt
            cell.performSelectAt = self.didPerformSelectRowAt
            cell.isHidden = !(self.filterPredicate?(item as! IObject) ?? true)
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding : CGFloat = 5.0
        
        let size = collectionView.frame.size.width / self.itemPerRow  - padding
        return CGSize(width: size , height: size )
    }
    private func isIndexPathValid(indexPath: IndexPath) -> Bool{
        return self.items.count > 0 && indexPath.row < self.items.count
    }
}
