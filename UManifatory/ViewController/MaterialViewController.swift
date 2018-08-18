//
//  ProjectViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/15/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class MaterialViewController : BaseViewController {
    var item : Material!
    var items: NSMutableArray = NSMutableArray()
    var collectionAdapter:CollectionAdapter!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollection()
        // Do any additional setup after loading the view.
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
            return isContains || self.item.ownerId == user.id
        }
        self.collectionAdapter.onDidSelectRowAt { (task) in
            if self.item.isIAmOwner() {
                self.performSegue(withIdentifier: Segue.material_to_assignworker, sender: task.getId())
            }
        }
        
        self.collectionView.delegate = self.collectionAdapter
        self.collectionView.dataSource = self.collectionAdapter
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initItem(itemId: String){
        self.showIndicatorDialog()
        WebApi.getMaterialById(id: itemId) { (material) in
            guard let mat = material else {
                Util.showAlert(message: "Material is not valid!")
                return
            }
            self.item = mat
            self.loadData()
            self.dismissIndicatorDialog()
        }
    }
    func loadData() {
        self.items.removeAllObjects()
        self.items.addObjects(from: self.item.tasks)
        self.collectionView.reloadData()
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Segue.material_to_assignworker {
            let taskId = sender as! String
            let VC = segue.destination as! AssignWotkerViewController
            VC.initData(materialId: self.item.id, taskId: taskId)
        }
    }
    

}
