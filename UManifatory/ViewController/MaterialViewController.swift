//
//  ProjectViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/15/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class MaterialViewController : BaseViewController {
    var materialId : String!
    var material : Material!
    var items: NSMutableArray = NSMutableArray()
    var collectionAdapter:CollectionAdapter!
    
    @IBOutlet weak var viewDescription: UIView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        self.viewDescription.isHidden = true
        super.viewDidLoad()
        initCollection()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        
    }
    @IBAction func gotoCreateTask(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.to_create_task, sender: self.material)
    }
    
    @IBAction func gotoDetail(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.material_to_detail, sender: self)
    }
    
    
    
    func initCollection() {
        let user = StoreUtil.getUser()!
        let cellIdentifier = TaskCollectionViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        
        self.collectionAdapter = CollectionAdapter(items:self.items, cellIdentifier: cellIdentifier,itemPerRow: 2, cellHeight : MaterialTableViewCell.height)
        
        self.collectionAdapter.filter { (tsk) -> Bool in
            let task = tsk as! Task
            let isContains = task.workers.contains(where: { (wk) -> Bool in
                return wk.owner.id == user.id
            })
            return isContains || self.material.ownerId == user.id
        }
        self.collectionAdapter.onDidSelectRowAt { (task) in
            if self.material.isIAmOwner() {
                self.performSegue(withIdentifier: Segue.material_to_assignworker, sender: task.getId())
            }
        }
        
        self.collectionView.delegate = self.collectionAdapter
        self.collectionView.dataSource = self.collectionAdapter
        
    }
    func loadData()  {
        self.showIndicatorDialog()
        WebApi.getMaterialById(id: self.materialId) { (material) in
            guard let mat = material else {
                Util.showAlert(message: "Material is not valid!")
                return
            }
            self.material = mat
            self.items.removeAllObjects()
            self.items.addObjects(from: self.material.tasks)
            self.collectionView.reloadData()
            if self.items.count == 0 {
                self.viewDescription.isHidden = false
            }
            self.dismissIndicatorDialog()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initItem(itemId: String){
        self.materialId = itemId;
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Segue.material_to_assignworker {
            let taskId = sender as! String
            let VC = segue.destination as! AssignWotkerViewController
            VC.initData(materialId: self.material.id, taskId: taskId)
        }
        else if segue.identifier == Segue.to_create_task {
            let VC = segue.destination as! CreateTaskViewController
            VC.initItem(item: self.material)
            
        }
        else if segue.identifier == Segue.material_to_detail {
            let VC = segue.destination as! MaterialDetailViewController
            VC.initItem(materialId: self.materialId)
        }
    }
    

}
