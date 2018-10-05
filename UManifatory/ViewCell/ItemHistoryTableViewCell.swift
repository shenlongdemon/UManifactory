//
//  ItemHistoryTableViewCell.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/26/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ItemHistoryTableViewCell: TableCell {
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    var item: ItemHistory!
    override func initData(object: IObject) {
        self.item = object as! ItemHistory
        self.item.getImage { (img) in
            self.imgImage.image = img
        }
        self.imgImage.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        self.lbName.text = self.item.name
        self.lbDate.text = Util.getDate(milisecond: self.item.time, format: Constant.Date_Format)
        self.lbTime.text = Util.getDate(milisecond: self.item.time, format: Constant.Hour_Format)
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func getFrame() -> CGRect {
        return self.frame
    }
    
    
    
    
    static let nibName = String(describing:  ItemHistoryTableViewCell.self)
    static let reuseIdentifier = String(describing: ItemHistoryTableViewCell.self)
    static let height : CGFloat = 80
}
