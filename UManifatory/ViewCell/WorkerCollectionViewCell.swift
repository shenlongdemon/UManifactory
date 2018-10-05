//
//  WorkerCollectionViewCell.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/18/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class WorkerCollectionViewCell: CollectionCell {
    var item : Worker!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func initData(object: IObject) {
        super.initData(object: object)
        self.item = object as! Worker
        
        self.lbName.text = "\(self.item.owner.lastName) \(self.item.owner.firstName)"
        self.item.owner.getImage { (img) in
            self.imgImage.image = img
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func getFrame() -> CGRect {
        return self.frame
    }
    
    
    
    
    static let nibName = String(describing:  WorkerCollectionViewCell.self)
    static let reuseIdentifier = String(describing: WorkerCollectionViewCell.self)
    static let height : CGFloat = 100

}
