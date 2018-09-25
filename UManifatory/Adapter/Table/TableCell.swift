//
//  TableItem.swift
//  EasyParking
//
//  Created by test on 7/27/17.
//  Copyright © 2017 omidx. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    var id : Any!
    var performSelect : ((IObject) -> Void)? = nil
    var performSelectAt : ((IObject, Int) -> Void)? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

