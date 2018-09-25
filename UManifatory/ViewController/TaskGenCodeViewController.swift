//
//  TaskGenCodeViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/19/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class TaskGenCodeViewController: BaseViewController {
    
    @IBOutlet weak var imgImage: UIImageView!
    var item: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgImage.image = Util.getQRCodeImage(str: self.item)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initItem(item: String){
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
