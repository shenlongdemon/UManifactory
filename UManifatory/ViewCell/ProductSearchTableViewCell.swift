//
//  ProductSearchTableViewCell.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 6/21/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductSearchTableViewCell: TableCell {
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbReview: UILabel!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgStar: UIImageView!
    
    @IBOutlet weak var lbRate: UILabel!
    
    @IBOutlet weak var imgReview: UIImageView!
    @IBOutlet weak var lbLink: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    var item : ProductSearch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func initData(object: IObject) {
        self.item = object as! ProductSearch
        self.lbTitle.text = self.item.title
        self.lbReview.text = "\(self.item.reviews.count) reviews"
        let url = URL(string: self.item.link)
        self.lbLink.text = url?.host ?? ""
        if self.item.rate > 0 {
            self.lbRate.text = "\(self.item.rate)"
            self.imgStar.image = #imageLiteral(resourceName: "star_hightlight")
        }
        else{
            self.lbRate.text = "No rating"
            self.imgStar.image = #imageLiteral(resourceName: "star_gray")
        }
        self.lbPrice.text = "\(self.item.price)"       
        self.item.getImage { (img) in
            self.imgImage.image = img
        }
        
        let reviewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(reviewImageTapped(tapGestureRecognizer:)))
        self.imgReview.isUserInteractionEnabled = true
        self.imgReview.addGestureRecognizer(reviewTapGestureRecognizer)
        
        let productImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(productImageTapped(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(productImageTapGestureRecognizer)
        
        let labelLinkTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(productImageTapped(tapGestureRecognizer:)))
        self.lbLink.isUserInteractionEnabled = true
        self.lbLink.addGestureRecognizer(labelLinkTapGestureRecognizer)
        
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    @objc func reviewImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.performSelectAt?(self.item, 1)
    }
    @objc func productImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.performSelectAt?(self.item, 0)
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
    
    static let nibName = String(describing:  ProductSearchTableViewCell.self)
    static let reuseIdentifier = String(describing: ProductSearchTableViewCell.self)
    static let height : CGFloat = 135
}
