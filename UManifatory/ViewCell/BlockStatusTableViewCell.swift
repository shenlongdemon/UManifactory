//
//  BlockStatusTableViewCell.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/16/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class BlockStatusTableViewCell: TableCell {
    
    @IBOutlet weak var lbHour: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var imgStatus: UIImageView!
    var item: Task!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func initData(object: IObject) {
        self.item = object as! Task
        self.lbName.text  = self.item.name.uppercased()
        self.lbDate.text = ""
        self.lbHour.text = ""
        
        if (self.item.isGenCode()) {
            self.imgImage.image = #imageLiteral(resourceName: "ico_qrcode")
            self.imgImage.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            self.selectionStyle = .none
        }
        else {
        
            self.imgImage.image = Util.getImage(data64: self.item.image)
            let lastActivity : Activity? = self.item.getLastActivity()
            self.lbDate.text = Util.getDate(milisecond: lastActivity?.time ?? 0, format: Constant.Date_Format)
            self.lbHour.text = Util.getDate(milisecond: lastActivity?.time ?? 0, format: Constant.Hour_Format)
            
            let status = self.item.getStatus()
            self.imgStatus.image = self.getStatusIco(status: status)
            
            
        }
        self.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getStatusIco(status: Enums.TaskStatus) -> UIImage? {
        var image: UIImage? = nil
        if status == Enums.TaskStatus.done {
            image = #imageLiteral(resourceName: "status_done")
            self.imgImage.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        else if status == Enums.TaskStatus.starting {
            image = #imageLiteral(resourceName: "status_starting")
            self.imgImage.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        return image
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func getFrame() -> CGRect {
        return self.frame
    }
    
    
    
    
    static let nibName = String(describing:  BlockStatusTableViewCell.self)
    static let reuseIdentifier = String(describing: BlockStatusTableViewCell.self)
    static let height : CGFloat = 75

}
