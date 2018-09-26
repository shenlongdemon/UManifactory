//
//  ReviewTableViewCell.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 7/1/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ReviewTableViewCell: TableCell {

    @IBOutlet weak var lbDescription: UITextView!
    var item : Review!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func initData(object: IObject) {
        self.item = object as! Review
        self.lbDescription.text = item.description
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
    
    static let nibName = String(describing:  ReviewTableViewCell.self)
    static let reuseIdentifier = String(describing: ReviewTableViewCell.self)
    static let height : CGFloat = 100
    
}
