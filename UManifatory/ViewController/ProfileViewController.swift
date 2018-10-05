//
//  ProfileViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/27/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import QRCode
class ProfileViewController: BaseViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgQRCode: UIImageView!
    
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfZipCode: UITextField!
    @IBOutlet weak var tfCountry: UITextField!
    
    let user = StoreUtil.getUser()!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user.getImage { (img) in
            self.imgProfile.image = img
        }
        self.imgQRCode.image = Util.getQRCodeImage(str: self.user.id)
        
        self.tfFirstName.text = self.user.firstName
        self.tfLastName.text = self.user.lastName
        self.tfState.text = self.user.state
        self.tfZipCode.text = self.user.zipCode
        self.tfCountry.text = self.user.country
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
