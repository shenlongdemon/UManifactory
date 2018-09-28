//
//  ProductTabBarViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/25/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initItem(item: Item){
        for (_, v) in (self.viewControllers?.enumerated())! {
            if let vc = v as? ItemAttachFilesViewController {
                vc.initItem(item: item)
            }
            else if let vc = v as? ItemInfoViewController {
                vc.initItem(item: item)
            }
            else if let vc = v as? ItemReviewsViewController {
                vc.initItem(item: item)
            }
            else if let vc = v as? ItemHistoryViewController {
                vc.initItem(item: item)
            }
            else if let vc = v as? MaterialDetailViewController {
                vc.initItem(itemId: item.id, materialId: item.material?.id ?? "")
            }
        }
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
