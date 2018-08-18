//
//  TaskCollectionViewCell.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/18/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class TaskCollectionViewCell: CollectionCell {
    
    @IBOutlet weak var lbName: UILabel!
    var item : Task!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   
    override func initData(object: IObject) {
        super.initData(object: object)
        self.item = object as! Task
        
        self.lbName.text = self.item.name.uppercased()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func getFrame() -> CGRect {
        return self.frame
    }
    
    
    
    
    static let nibName = String(describing:  TaskCollectionViewCell.self)
    static let reuseIdentifier = String(describing: TaskCollectionViewCell.self)
    static let height : CGFloat = 100

}
