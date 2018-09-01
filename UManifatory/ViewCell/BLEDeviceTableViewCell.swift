//
//  BLEDeviceTableViewCell.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/23/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class BLEDeviceTableViewCell: TableCell {

    var item : BLEDevice!    

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func initData(object: IObject) {
        super.initData(object: object)
        self.item = object as! BLEDevice
        self.lbName.text = self.item.name
        self.lbId.text = self.item.id
        
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func getFrame() -> CGRect {
        return self.frame
    }
    
    
    
    
    static let nibName = String(describing:  BLEDeviceTableViewCell.self)
    static let reuseIdentifier = String(describing: BLEDeviceTableViewCell.self)
    static let height : CGFloat = 60
    
    
}
