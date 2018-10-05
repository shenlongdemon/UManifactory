//
//  CreateTaskViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/23/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class CreateTaskViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var item: Material!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var imgImage: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage(tapGestureRecognizer:)))
        self.imgImage.isUserInteractionEnabled = true
        self.imgImage.addGestureRecognizer(tapGestureRecognizer)
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
    @IBAction func saveTask(_ sender: Any) {
        let imgs : [UIImage] = [self.imgImage.image ?? #imageLiteral(resourceName: "photo")]
        let imgNames : [String] = [("\(NSUUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")).jpg")]
        let name = self.tfTitle.text ?? ""
        let description = self.tvDescription.text ?? ""
        self.showIndicatorDialog()
        
        Util.getUesrInfo { (ui) in
            guard let userInfo = ui else {
                Util.showAlert(message: "Error !!!")
                return
            }
            WebApi.createTask(materialId: self.item.id, title: name, description: description, imageUrl: imgNames[0], userInfo: userInfo, completion: { (t) in
                
                if let task = t {
                    WebApi.uploadActivityImages(taskId: task.id, images: imgs, names: imgNames, completion: { (done) in
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
    func initItem(item: Material){
        self.item = item
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
