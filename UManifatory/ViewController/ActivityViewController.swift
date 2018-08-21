//
//  TaskViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/18/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import ImageSlideshow
import ImagePicker
class ActivityViewController: BaseViewController, ImagePickerDelegate {
    @IBOutlet weak var imageSlide: ImageSlideshow!
    var imagePicker : ImagePickerController!;
    var materialId: String!
    var taskId: String!
    var workerId: String!
    var images : [UIImage] = []
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = Configuration()
        config.doneButtonTitle = "Finish"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        config.allowVideoSelection = true
        
        imagePicker = ImagePickerController(configuration: config)
        imagePicker.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    func initData(materialId : String!, taskId: String!, workerId: String?){
        if let _ = workerId {
            self.workerId = workerId!
        }
        else {
            let user = StoreUtil.getUser()!
            self.workerId = user.id
        }
        self.materialId = materialId
        self.taskId = taskId
    }
    
    @IBAction func selectImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard self.images.count > 0 else {
            Util.showAlert(message: "Please select some images!!!")
            return
        }
        var names : [String] = []
        for (_, _) in self.images.enumerated() {
            names.append("\(NSUUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")).jpg")
        }
        
        let title = self.txtTitle.text ?? ""
        let description = self.txtDescription.text ?? ""
        
        self.showIndicatorDialog()
        WebApi.saveActivity(self.materialId, self.taskId, self.workerId, title, description, names) { (done) in
            
            if done {
                WebApi.uploadActivityImages(taskId: self.taskId, images: self.images, names: names, completion: { (finished) in
                    self.dismissIndicatorDialog()
                    if finished {
                        Util.showAlert(message: "Done !!!", okHandle: {
                            self.back()
                        })
                    }
                    else {
                        Util.showAlert(message: "Error when add activity!!!!!")
                    }
                })
                
            }
            else {
                self.dismissIndicatorDialog()
                Util.showAlert(message: "Error when add activity!!!!!")
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let imageSources = images.flatMap { (img) -> ImageSource! in
            return ImageSource(image: img)
        }
        imageSlide.setImageInputs(imageSources)
        self.images = images
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
