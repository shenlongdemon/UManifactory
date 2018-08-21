//
//  AdminTaskViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/18/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import AVFoundation
import UIKit
import QRCodeReader

/* Admin feature - assign workers into task */
class AssignWotkerViewController: BaseViewController, QRCodeReaderViewControllerDelegate{
    @IBOutlet weak var collectionView: UICollectionView!
    var materialId: String!
    var taskId: String!
    var material: Material!
    var items: NSMutableArray = NSMutableArray()
    var collectionAdapter:CollectionAdapter!
    var isScanning: Bool = false
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader          = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollection()
        // Do any additional setup after loading the view.
    }
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
   
    @IBAction func startScanQRCode(_ sender: Any) {
        self.startScan()
    }
    func assignWorker(workerId: String){
        
        let task = material.getTask(id: self.taskId)!
        if let _ = task.getWorker(id: workerId){
            Util.showAlert(message: "This worker is assigned!")
        }
        else {
            self.showIndicatorDialog()
            WebApi.assignWorkerToTask(materialId: materialId, taskId: taskId, workerId: workerId, completion: { (wk) in
                self.dismissIndicatorDialog()
                if let worker = wk{
                    let task = self.material.getTask(id: self.taskId)!
                    task.workers.append(worker)
                    
                    self.items.removeAllObjects()
                    self.items.addObjects(from: task.workers)
                    self.collectionView.reloadData()
                    Util.showAlert(message: "Assign done!")
                }
                else {
                    Util.showAlert(message: "Cannot assign!")
                }
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initData(materialId: String, taskId : String){
        self.materialId = materialId
        self.taskId = taskId
        self.showIndicatorDialog()
        WebApi.getMaterialById(id: self.materialId) { (mat) in
            self.material = mat as! Material
            self.loadData()
            self.dismissIndicatorDialog()
        }
    }
    func startScan() {
        guard checkScanPermissions() else { return }
        self.isScanning = true
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        present(readerVC, animated: true, completion: nil)
    }
    func initCollection() {
        
        let cellIdentifier = WorkerCollectionViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        
        self.collectionAdapter = CollectionAdapter(items:self.items, cellIdentifier: cellIdentifier,itemPerRow: 2, cellHeight : WorkerCollectionViewCell.height)
        
        self.collectionAdapter.onDidSelectRowAt { (worker) in
            self.performSegue(withIdentifier: Segue.assignworker_to_activity, sender: worker)
        }
        
        self.collectionView.delegate = self.collectionAdapter
        self.collectionView.dataSource = self.collectionAdapter
        
    }
    func loadData(){
        self.items.removeAllObjects()
        let task = self.material.tasks.first { (t) -> Bool in
            return t.id == self.taskId
        } as! Task
        
        self.items.addObjects(from: task.workers)
        self.collectionView.reloadData()
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
        
        
        
        reader.stopScanning()
        self.isScanning = false
        self.processQRCode(qrCode: result.value)
        
        dismiss(animated: true) { [weak self] in
            
        }
    }
    func processQRCode(qrCode: String) {
        if (self.isScanning == false){
            
            let task = material.getTask(id: self.taskId)!
            if let _ = task.getWorker(id: qrCode){
                Util.showAlert(message: "This worker is assigned!")
            }
            else {
                self.showIndicatorDialog()
                WebApi.getUserById(id: qrCode, completion: { (u) in
                    self.dismissIndicatorDialog()
                    if let user = u {
                        Util.showYesNoAlert(VC: self, message: "Do you want to assign \(user.firstName) to this task ?", yesHandle: { () in
                            self.assignWorker(workerId: user.id)
                        }, noHandle: { () in
                            
                        })
                        
                    }
                    else {
                        Util.showAlert(message: "The code is invalid!!!")
                    }
                })
            }
        }
        
        
        
    }
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.assignworker_to_activity {
            let worker = sender as! Worker
            let VC = segue.destination as! ActivityViewController
            VC.initData(materialId: self.materialId, taskId: self.taskId, workerId: worker.owner.id)
        }
    }
    

}
