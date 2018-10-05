//
//  ActivityTableViewCell.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/23/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ActivityTableViewCell: TableCell {

    var item : Activity!
    
    @IBOutlet weak var lbHour: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    
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
        self.item = object as! Activity
        self.lbTitle.text = self.item.title
        self.tvDescription.text = self.item.description
        self.lbDate.text = Util.getDate(milisecond: self.item.time, format: "yyyy-MM-dd")
        self.lbHour.text = Util.getDate(milisecond: self.item.time, format: "HH:mm a")
        self.item.worker.getImage { (img) in
            self.imgImage.image = img
        }
        
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
    
    
    
    
    static let nibName = String(describing:  ActivityTableViewCell.self)
    static let reuseIdentifier = String(describing: ActivityTableViewCell.self)
    static let height : CGFloat = 100
    
}
