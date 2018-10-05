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
    var code: String = ""
    var time: Int64 = Util.getCurrentMillis()
    var logoUrl: String = ""
    @IBOutlet weak var tvCode: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(qrCodeImageTapped(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer)
        self.imgImage.image = Util.getQRCodeImage(str: self.code)
        // Do any additional setup after loading the view.
        self.tvCode.text = self.code
        AppUtil.getImage(imageName: self.logoUrl) { (img) in
            self.imgTask.image = img
        }
        self.lbDate.text = Util.getDate(milisecond: self.time, format: Constant.Date_Format)
    }
    
    @objc func qrCodeImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if self.code != "" {
            WebApi.getDescriptionQRCode(code: self.code) { (description) in
                Util.showOKAlert(VC: self, message: description);
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initItem(code: String, time: Int64, logoUrl: String){
        self.code = code
        self.time = time
        self.logoUrl = logoUrl
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
