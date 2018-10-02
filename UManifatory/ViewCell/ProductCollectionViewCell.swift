//
//  ProductCollectionViewCell.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 6/8/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: CollectionCell {
    var item: Item!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lbName: UILabel!
    
    
    override func initData(object: IObject) {
        super.initData(object: object)
        self.item = object as! Item
        
        self.lbName.text = "\(self.item.owner.lastName) \(self.item.owner.firstName)"
        self.imgImage.image = self.item.getImage()
        self.lbPrice.text = "\(self.item.price)"
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override convenience init(frame: CGRect) {
        self.init(frame: frame)
    }

    static let nibName = String(describing:  ProductCollectionViewCell.self)
    static let reuseIdentifier = String(describing: ProductCollectionViewCell.self)
    static let height : CGFloat = 100
}
