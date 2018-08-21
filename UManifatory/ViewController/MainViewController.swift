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

        // Do any additional setup after loading the view.
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
    override func processQRCode(qrCode: String) {
        Util.showAlert(message: "\(qrCode)")
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
