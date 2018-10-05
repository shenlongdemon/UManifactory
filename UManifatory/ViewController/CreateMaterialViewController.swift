//
//  CreateMaterialViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/23/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class CreateMaterialViewController: BaseViewController, ChoiceProto, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var tfDescription: UITextView!
    
    @IBOutlet weak var lbBluetoothId: UILabel!
    @IBOutlet weak var tfBluetooth: UITextField!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var imgImage: UIImageView!
    var bleDevice: BLEDevice? = nil
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    @IBAction func gotoBluetooth(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.creatematerial_to_bluetooth, sender: nil)
    }
    @objc func pickImage(tapGestureRecognizer: UITapGestureRecognizer)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let image = Util.resizeImage(image: pickedImage)
            imgImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveMaterial(_ sender: Any) {
        self.createMaterial()
    }
    func createMaterial(){
        let imgs : [UIImage] = [self.imgImage.image ?? #imageLiteral(resourceName: "photo")]
        let imgNames : [String] = [("\(NSUUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")).jpg")]
        let name = self.tfTitle.text ?? ""
        let description = self.tfDescription.text ?? ""
        let user = StoreUtil.getUser()!
        self.showIndicatorDialog()
        Util.getUesrInfo { (ui) in
            guard let userInfo = ui else {
                return
            }
            WebApi.createMaterial(ownerId: user.id, title: name, description: description, imageUrl: imgNames[0], bluetooth: self.bleDevice, userInfo: userInfo, completion: { (mat) in
                if let material = mat {
                    WebApi.uploadActivityImages(taskId: material.id, images: imgs, names: imgNames, completion: { (done) in
                        self.dismissIndicatorDialog()
                        if done {
                            self.back()
                        }
                        else {
                            Util.showAlert(message: "Error !!!")
                        }
                    })                    
                }
                else {
                    self.dismissIndicatorDialog()
                    Util.showAlert(message: "Error !!!")
                }
            })
            
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Segue.creatematerial_to_bluetooth {
            let VC = segue.destination as! BluetoothDeviceViewController
            VC.initItem(choiceProto: self)
        }
    }
    func select(device: BLEDevice) {
        self.bleDevice = device
        let name = (self.bleDevice?.name ?? "").count > 0 ? self.bleDevice!.name : (self.bleDevice?.id ?? "")
        self.tfBluetooth.text = name
        self.lbBluetoothId.text = self.bleDevice!.id
    }

}
