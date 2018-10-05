//
//  MainViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/15/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class MainViewController: BaseQRCodeReaderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background_main"))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background_main"))
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startScanQRCode(_ sender: Any) {
        self.startScan()
    }
    @IBAction func gotoBluetoothView(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.main_to_bluetoothproduct_around, sender: self)
    }
    
    @IBAction func gotoProfile(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.main_to_profile, sender: nil)
    }
    override func processQRCode(qrCode: String) {
        if self.isScanning == false {
            self.showIndicatorDialog()
            WebApi.getObjectByQRCode(qrcode: qrCode, completion: { (result) in
                self.dismissIndicatorDialog()
                
                if let resultItem = result {
                    if resultItem.type == Enums.ScanQRItemType.material {
                        if let material: Material = (resultItem.item as? NSDictionary)?.cast(){
                            self.handle(material: material, qrcode: qrCode)
                        }
                    }
                    else if resultItem.type == Enums.ScanQRItemType.product {
                        if let product: Item = (resultItem.item as? NSDictionary)?.cast(){
                            self.handleForItem(item: product, qrcode: qrCode)
                        }
                    }
                }
            })
        }
    }
    @IBAction func gotoIProducts(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.main_to_items, sender: nil)
    }
    @IBAction func gotoSearch(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.main_to_search, sender: nil)
    }
    
    func handleForMaterial(material: Material) {
        
        if material.isIAmOwner() {
            self.performSegue(withIdentifier: Segue.main_to_material, sender: material)
        }
        else {            
            Util.showAlert(message: "The code is invalid!!!")
        }
    }
    func handleForTask(task: Task ) {
        if task.isIAmOwner(){
            self.performSegue(withIdentifier: Segue.main_to_activity, sender: task)
        }
        else {
            Util.showAlert(message: "The code is invalid!!!")
        }
    }
    func handle(material: Material, qrcode: String){
        if material.code == qrcode {
            handleForMaterial(material: material)
        }
        else {
            if material.hasMyTasks() || material.isIAmOwner() {
                self.performSegue(withIdentifier: Segue.main_to_material, sender: material)
            }
            else {
                Util.showAlert(message: "The code is invalid!!!")
            }            
        }
    }
    func handleForItem(item: Item, qrcode: String){
        self.performSegue(withIdentifier: Segue.main_scan_to_product, sender: item)
    }
    @IBAction func gotoMyMaterials(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.main_to_mymaterial, sender: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Segue.main_to_material {
            let material = sender as! Material
            let VC = segue.destination as! MaterialViewController
            VC.initItem(itemId: material.id)
        }
        else if segue.identifier == Segue.main_to_activity {
            let task = sender as! Task
            let user = StoreUtil.getUser()!
            let VC = segue.destination as! ActivityViewController
            VC.initData(itemId: "", materialId: task.materialId, taskId: task.id, workerId: user.id)
        }
        else if segue.identifier == Segue.main_to_mymaterial {
            let VC = segue.destination as! MyMaterialsViewController
            VC.initItem(choiceMyMaterialProto: nil)
        }
        else if segue.identifier == Segue.main_scan_to_product {
            let item =  sender as! Item
            let VC = segue.destination as! ProductTabBarViewController
            VC.initItem(item: item)         
        }
    }
    

}
