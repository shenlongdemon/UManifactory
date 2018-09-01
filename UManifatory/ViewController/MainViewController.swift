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
        self.performSegue(withIdentifier: Segue.main_to_bluetooth, sender: self)
    }
    
    @IBAction func gotoProfile(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.main_to_profile, sender: nil)
    }
    override func processQRCode(qrCode: String) {
        if self.isScanning == false {
            self.showIndicatorDialog()
            WebApi.getMaterialByQRCode(qrcode: qrCode, completion: { (mat) in
                self.dismissIndicatorDialog()
                if let material = mat {
                    
                    self.handle(material: material, qrcode: qrCode)
                    
                }
            })
        }
    }
    @IBAction func gotoIProducts(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.main_to_items, sender: nil)
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
            if material.hasMyTasks() {
                self.performSegue(withIdentifier: Segue.main_to_material, sender: material)
            }
            else {
                Util.showAlert(message: "The code is invalid!!!")
            }            
        }
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
            VC.initData(materialId: task.materialId, taskId: task.id, workerId: user.id)
        }
        else if segue.identifier == Segue.main_to_mymaterial {
            let _ = segue.destination as! MyMaterialsViewController
        }
    }
    

}
