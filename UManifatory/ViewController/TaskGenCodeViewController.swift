//
//  TaskGenCodeViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/19/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class TaskGenCodeViewController: BaseViewController {
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var imgTask: BaseImage!
    @IBOutlet weak var imgImage: UIImageView!
    var item: String = ""
    var time: Int64 = Util.getCurrentMillis()
    var logo: UIImage?
    @IBOutlet weak var tvCode: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgImage.image = Util.getQRCodeImage(str: self.item)
        // Do any additional setup after loading the view.
        self.tvCode.text = self.item
        self.imgTask.image = logo
        self.lbDate.text = Util.getDate(milisecond: self.time, format: Constant.Date_Format)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initItem(item: String, time: Int64, logo: UIImage?){
        self.item = item
        self.time = time
        self.logo = logo
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
