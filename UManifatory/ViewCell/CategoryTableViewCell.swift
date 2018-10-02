//
//  CategoryTableViewCell.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class CategoryTableViewCell: TableCell {

    @IBOutlet weak var lbName: UILabel!
    var category : Category!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func initData(object: IObject) {
        self.category = object as! Category
        self.lbName.text = "\(self.category.value)"
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
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
    
    //    @IBOutlet weak var lbModel: UILabel!
    //    @IBOutlet weak var lbManufacture: UILabel!
    //    @IBOutlet weak var lbLicensePlate: UILabel!
    
    @IBOutlet weak var lbPrice: UILabel!
    
    
    static let nibName = String(describing:  CategoryTableViewCell.self)
    static let reuseIdentifier = String(describing: CategoryTableViewCell.self)
    static let height : CGFloat = 70
    
}
