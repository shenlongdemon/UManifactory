//
//  PDTFilesTableViewCell.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/17/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class PDTFilesTableViewCell: TableCell {
    @IBOutlet weak var lbFileName: UILabel!
    var item: IObject!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func initData(object: IObject) {
        self.item = object
        self.lbFileName.text = self.item.getId()
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
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
    
    static let nibName = String(describing:  PDTFilesTableViewCell.self)
    static let reuseIdentifier = String(describing: PDTFilesTableViewCell.self)
    static let height : CGFloat = 45
}
