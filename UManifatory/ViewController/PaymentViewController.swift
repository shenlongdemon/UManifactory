//
//  PaymentViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 10/3/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController {
    var item: Item!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func payment(_ sender: Any) {
        self.showIndicatorDialog()
        Util.getUesrInfo { (userInfo) in
            if let userI = userInfo {
                WebApi.payment(itemId: self.item.id, userInfo: userI, completion: { (i) in
                    self.dismissIndicatorDialog()
                    if let _ = i {
                        self.bactToRoot()
                    }
                    else {
                        Util.showAlert(message: "Cannot buy this item")
                    }
                    
                })
            }
            else {
                self.dismissIndicatorDialog()
            }
        }
    }
    func initItem(item: Item){
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
