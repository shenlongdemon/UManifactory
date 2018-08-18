//
//  AdminTaskViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/18/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

/* Admin feature - assign workers into task */
class AssignWotkerViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var materialId: String!
    var taskId: String!
    var material: Material!
    var items: NSMutableArray = NSMutableArray()
    var collectionAdapter:CollectionAdapter!
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollection()
        // Do any additional setup after loading the view.
    }

    @IBAction func assign(_ sender: Any) {
        let user = StoreUtil.getUser()!
        self.assignWorker(workerId: user.id)
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.assignworker_to_activity {
            
        }
    }
    

}
