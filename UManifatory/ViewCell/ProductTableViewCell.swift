//
//  CategoryTableViewCell.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductTableViewCell: TableCell {
    
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbOwner: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var imgNext: UIButton!
    
    @IBOutlet weak var heightImage: NSLayoutConstraint!
    
    @IBOutlet weak var lbBluetoothName: UILabel!
    @IBOutlet weak var imgBluetooth: UIImageView!
    var item : Item!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func initData(object: IObject) {
        self.item = object as! Item
       
        if (self.item.id.count > 0){
            heightImage.constant = 95
            self.lbName.text = "\(self.item.name)"
            self.imgImage.image = item.getImage()
            self.lbCategory.text = self.item.category.value
            
            self.lbPrice.text = "$ \(self.item.price)"
            self.lbOwner.text = "\(self.item.owner.lastName )"
            self.lbStatus.text = ""
            if self.item.buyerCode.count > 0 {
                self.lbStatus.text = "SOLD by \(self.item.buyer?.firstName ?? "" )"
                self.lbStatus.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            }
            else if self.item.sellCode.count > 0 {
                self.lbStatus.text = "PUBLISH"
                self.lbStatus.textColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
            }
            if let bluetooth = self.item.bluetooth {
                self.imgBluetooth.image = #imageLiteral(resourceName: "bluetooth")
                self.lbBluetoothName.text = bluetooth.name
            }
            else {
                self.imgBluetooth.image = nil
                self.lbBluetoothName.text = ""
            }
        }
        else{
            heightImage.constant = 0.0
            
            self.lbName.text = self.item.name
            self.lbCategory.text = self.item.bluetoothCode
            self.lbPrice.text = self.item.price
            self.lbStatus.text = ""
            self.lbOwner.text = self.item.description
            
            
        }
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
    
    
    
    
    static let nibName = String(describing:  ProductTableViewCell.self)
    static let reuseIdentifier = String(describing: ProductTableViewCell.self)
    static let height : CGFloat = 140
    
}

