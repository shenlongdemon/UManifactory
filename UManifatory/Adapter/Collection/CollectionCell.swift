//
//  CollectionCell.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/18/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    var id : Any!
    var performSelect : ((IObject) -> Void)? = nil
    var performSelectAt : ((IObject, Int) -> Void)? = nil
   
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func initData(object: IObject) {
        self.id = object.getId()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func getFrame() -> CGRect {
        return self.frame
    }
    
}
