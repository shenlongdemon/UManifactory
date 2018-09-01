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
import MobileCoreServices
import FileBrowser
class ActivityViewController: BaseViewController, ImagePickerDelegate, UIDocumentPickerDelegate, UIDocumentMenuDelegate {
    
    @IBOutlet weak var lbDatetime: UILabel!
    
    
    @IBOutlet weak var imageSlide: ImageSlideshow!
    var imagePicker : ImagePickerController!;
    var materialId: String!
    var taskId: String!
    var workerId: String!
    var images : [UIImage] = []
    
    @IBOutlet weak var lbAttackFile: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    let documentPicker = UIDocumentPickerViewController(documentTypes: NSArray(object: kUTTypePDF as NSString) as! [String], in: .import)
    var fileUrls : [URL] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let now = (Int64)(Date().timeIntervalSince1970 * 1000)
        self.lbDatetime.text = "\(Util.getDate(milisecond: now, format: "yyyy/MM/dd hh:mm a"))"
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        
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
    @IBAction func attackFile(_ sender: Any) {
//        let fileBrowser = FileBrowser()
//        self.present(fileBrowser, animated: true, completion: nil)
//        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
//
//        }
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    
        
        //self.present(documentPicker, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // you get from the urls parameter the urls from the files selected
        
        self.fileUrls = urls
        let fileName = self.fileUrls[0].lastPathComponent
        self.lbAttackFile.text = fileName
    }

    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        self.present(self.documentPicker, animated: true, completion: nil)
    }
    func loadData() {
        
        
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
        var files : [String] = []
        for (_, fileUrl) in self.fileUrls.enumerated() {
            let fileName = fileUrl.lastPathComponent
            let p = fileName.split(separator: ".")
            files.append("\(p[0])_\(NSUUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")).\(p[1])")
        }
        
        
        let title = self.txtTitle.text ?? ""
        let description = self.txtDescription.text ?? ""
        
        self.showIndicatorDialog()
        Util.getUesrInfo { (ui) in
            guard let userInfo = ui else {
                return
            }
            WebApi.saveActivity(self.materialId, self.taskId, self.workerId, title, description, names, files, userInfo) { (done) in
                
                if done {
                    WebApi.uploadActivityImages(taskId: self.taskId, images: self.images, names: names, completion: { (finished) in
                        
                        if finished {
                            if self.fileUrls.count > 0 {
                                WebApi.uploadActivityFiles(taskId: self.taskId, fileUrls: self.fileUrls, names: files, completion: { (fileOK) in
                                    if fileOK {
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
                                Util.showAlert(message: "Done !!!", okHandle: {
                                    self.back()
                                })
                            }
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
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.loadData()
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Segue.activity_to_detail {
            let activity = sender as! Activity
            let VC = segue.destination as! ActivityDetailViewController
            VC.initItem(item: activity)
        }
    }
    

}
