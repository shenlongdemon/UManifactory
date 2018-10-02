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
    
    @IBOutlet weak var btnAction: BaseButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageSlideShow.setImageInputs( AppUtil.getInputSources(item: self.item) )
        self.tvDescription.text = item.getAllDescription()
        // Do any additional setup after loading the view.
        self.lbName.text = self.item.name
        
        self.makeButtonAction()
    }
    func makeButtonAction() -> Enums.ItemActionType{
        var title = "SELL"
        let user = StoreUtil.getUser()!
        var action = Enums.ItemActionType.sell
        self.btnAction.isEnabled = true
        self.btnAction.isHidden = false
        if item.owner.id == user.id { // it is mine
            action = Enums.ItemActionType.sell
            title = "SELL"
            if self.item.isPublish() {
                action = Enums.ItemActionType.cancel_sell
                title = "CANCEL SELL"
            }
           
            if (self.item.buyerCode.count > 0){ // someone buys it
                title = ""
                action = Enums.ItemActionType.no
                self.btnAction.isHidden = true
            }
        }
        else if item.owner.id != user.id { // not mine
            action = Enums.ItemActionType.buy
            title = "BUY"
            if let buyer = item.buyer {
                if buyer.id == user.id { // buyer is me --> confirm that received item
                    action = Enums.ItemActionType.confirm_buy
                    title = "COMFIRM"
                }
            }
        }
        self.btnAction.setTitle(title, for: .normal)
        return action
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doAction(_ sender: Any) {
        self.showIndicatorDialog()
        let action = self.makeButtonAction()
        if action == Enums.ItemActionType.cancel_sell {
            self.cancelSell()
        }
        else if action == Enums.ItemActionType.sell {
            self.publishSell()
        }
        else if action == Enums.ItemActionType.buy {
            self.buy()
        }
        else if action == Enums.ItemActionType.confirm_buy {
            self.confirmBuy()
        }
    }
    
    func buy() {
        self.performSegue(withIdentifier: Segue.itemdetail_to_payment, sender: self.item)
    }
    
    func confirmBuy() {
        Util.showYesNoAlert(VC: self, message: "You received product and comfirm?", yesHandle: { (_) in
            self.showIndicatorDialog()
            WebApi.confirmReceived(itemId: self.item.id, completion: { (done) in
                self.dismissIndicatorDialog()
                if (done) {
                    self.bactToRoot()
                }
                else{
                    Util.showOKAlert(VC: self, message: "Error when confirm")
                }
                
            })
        }) { () in
            
        }
        
    }
    
    func publishSell() {
        Util.getUesrInfo { (history) in
            if let his = history {
                self.showIndicatorDialog()
                WebApi.publishSell(itemId: self.item.id, ownerInfo: his, completion: { (i) in
                    self.dismissIndicatorDialog()
                    if let itm = i {
                        self.back()
                    }
                    else {
                        Util.showOKAlert(VC: self, message: "Cannot publish item to sell.")
                    }
                })
            }
        }
    }
    
    func cancelSell() {
        self.showIndicatorDialog()
        WebApi.cancelSell(itemId: self.item.id, completion: { (done) in
            self.dismissIndicatorDialog()
            if (done) {
                self.back()
            }
            else{
                Util.showOKAlert(VC: self, message: "Error when cancelling.")
            }
            
        })
        
    }
    
    func initItem(item: Item) {
        self.item = item
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.itemdetail_to_payment {
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
