//
//  CreateIProductViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/25/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import DropDown
class CreateIProductViewController: BaseQRCodeReaderViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChoiceProto, ChoiceMaterialProto,UITextFieldDelegate {

    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfBluetooth: UITextField!
    
    @IBOutlet weak var tfBluetoothSource: UITextField!
    @IBOutlet weak var lbBluetooth: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var lbBluetoothSource: UILabel!
    let imagePicker = UIImagePickerController()
    
    var categories: [Category] = []
    let dropDown = DropDown()
    var selectCategpry : Category?
    var bluetoothDevice: BLEDevice?
    var bluetoothLinkDevice: BLEDevice?
    var material: Material?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer)
        
        dropDown.anchorView = self.tfCategory
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectCategpry = self.categories[index]
            self.tfCategory.text = item
        }
        self.tfCategory.tag = 999
        self.tfCategory.delegate = self
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 999 {            
            return false
        }
        return true
    }
    func loadCategories(){
        self.showIndicatorDialog()
        WebApi.getCategories { (list) in
            self.dismissIndicatorDialog()
            self.categories.removeAll()
            self.categories.append(contentsOf: list)
            let names = list.map({ (cate) -> String in
                return cate.value
            })
            self.dropDown.dataSource = names
        }
    }
    
    @IBAction func scanQR_Material(_ sender: Any) {
        self.startScan()
    }
    
    override func processQRCode(qrCode: String) {
        if self.isScanning == false {
            self.showIndicatorDialog()
            WebApi.getObjectByQRCode(qrcode: qrCode, completion: { (result) in
                self.dismissIndicatorDialog()
                
                if let resultItem = result {
                    if resultItem.type == Enums.ScanQRItemType.material {
                        if let material: Material = (resultItem.item as? NSDictionary)?.cast(){
                            self.selectMaterial(material: material)
                            
                        }
                    }
                }
            })
        }
    }
    @IBAction func showDropdown(_ sender: Any) {
        dropDown.show()
    }
    @IBAction func touchDown(_ sender: Any) {
         dropDown.show()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func bluetoothForItem(_ sender: Any) {
       
        self.performSegue(withIdentifier: Segue.additem_to_bluetooth, sender: nil)
    }
    
    @IBAction func bluetoothForSource(_ sender: Any) {
        
        self.performSegue(withIdentifier: Segue.additem_to_bluetoottmaterial, sender: nil)
    }
    
    func select(device: BLEDevice) {
        
        self.bluetoothDevice = device
        // self.tfBluetooth.text = device.getName()
        self.lbBluetooth.text = device.id
        
    }
    func selectMaterial(material: Material){
        self.material = material
        self.tfBluetoothSource.text = self.material?.name ?? ""
        self.lbBluetoothSource.text = self.material?.bluetooth ?? ""
    }
    @IBAction func save(_ sender: Any) {
        guard  let cat = self.selectCategpry else {
            Util.showOKAlert(VC: self, message: "Please select category")
            return
        }
        let imgs : [UIImage] = [self.imgImage.image ?? #imageLiteral(resourceName: "photo")]
        let imgNames : [String] = [("\(NSUUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")).jpg")]
        self.showIndicatorDialog()
        let device = self.bluetoothDevice?.id ?? ""
        self.bluetoothDevice?.proximityUUID = (self.tfBluetooth.text ?? "").uppercased()
        let item : Item = Item()
        item.name = tfName.text!
        item.price = tfPrice.text!
        item.description = tvDescription.text
        item.category = cat
        item.imageUrl = imgNames[0]
        item.bluetoothCode = device
        item.iBeacon = self.bluetoothDevice
        item.material = self.material
        item.maintains = []
        Util.getUesrInfo { (history) in
            if let his = history {
                if let ble = self.bluetoothDevice {
                    item.location = BLEPosition()
                    item.location.coord = ble.coord
                }
                item.owner = his
                WebApi.addItem(item: item, completion: { (item) in
                    if let it = item {
                        WebApi.uploadActivityImages(taskId: it.id, images: imgs, names: imgNames, completion: { (done) in
                            self.dismissIndicatorDialog()
                            if done {
                                self.back()
                            }
                            else {
                                Util.showAlert(message: "Error !!!")
                            }
                        })
                    }
                    else{
                        Util.showOKAlert(VC: self, message: "Cannot add item")
                    }
                    
                    
                })
            }
            else{
                self.dismissIndicatorDialog()
            }
        }
    }
    
    @IBAction func selectMyMaterial(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.additem_to_mymaterial, sender: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Segue.additem_to_bluetooth {
            let vc = segue.destination as! BluetoothDeviceViewController
            vc.initItem(choiceProto: self)
        }
        else if segue.identifier == Segue.additem_to_bluetoottmaterial {
            let vc = segue.destination as! BluetoothViewController
            vc.initProto(choiceMaterialProto: self)
        }
        else if segue.identifier == Segue.additem_to_mymaterial {
            let vc = segue.destination as! MyMaterialsViewController
            vc.initItem(choiceMyMaterialProto: self)
        }
    }
}
extension CreateIProductViewController : ChoiceMyMaterialProto {
    func select(material: Material) {
        self.selectMaterial(material: material)
    }
}

