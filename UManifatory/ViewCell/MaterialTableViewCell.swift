//
//  MaterialTableViewCell.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/18/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class MaterialTableViewCell: TableCell {

    var item : Material!
    
    @IBOutlet weak var lbModifiedAt: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!
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
        self.item = object as! Material
        self.lbName.text = self.item.name
        self.item.getImage { (img) in
            self.imgImage.image  = img
        }
        self.lbModifiedAt.text = Util.getDate(milisecond: self.item.updatedAt, format: "yyyy-MM-dd")
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
    
    
    
    
    static let nibName = String(describing:  MaterialTableViewCell.self)
    static let reuseIdentifier = String(describing: MaterialTableViewCell.self)
    static let height : CGFloat = 70
    
}
