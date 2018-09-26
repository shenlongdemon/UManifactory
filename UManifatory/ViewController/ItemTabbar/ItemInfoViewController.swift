//
//  ItemInfoViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/19/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import ImageSlideshow
class ItemInfoViewController: BaseViewController {
    var item: Item!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    override func viewDidLoad() {
        super.viewDidLoad()
    self.imageSlideShow.setImageInputs( AppUtil.getInputSources(item: self.item) )
        self.tvDescription.text = item.getAllDescription()
        // Do any additional setup after loading the view.
        self.lbName.text = self.item.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initItem(item: Item) {
        self.item = item
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
