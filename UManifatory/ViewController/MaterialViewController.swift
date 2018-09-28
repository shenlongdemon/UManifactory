//
//  ProjectViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/15/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import UICircularProgressRing
class MaterialViewController : BaseViewController {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var viewPercent: UICircularProgressRing!
    
    var materialId : String!
    var material : Material!
    var items: NSMutableArray = NSMutableArray()
    var tableAdapter:TableAdapter!
    
    @IBOutlet weak var viewDescription: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        self.viewDescription.isHidden = true
        super.viewDidLoad()
        viewPercent.maxValue = 100
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
        let cellIdentifier = BlockStatusTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : BlockStatusTableViewCell.height)
        self.tableAdapter.filter { (tsk) -> Bool in
            if (self.material.ownerId == user.id){
                return true;
            }
            let task = tsk as! Task
            let isContains = task.workers.contains(where: { (wk) -> Bool in
                return wk.owner.id == user.id
            })
            return isContains
        }
        self.tableAdapter.onDidSelectRowAt { (task) in
            let t = task as! Task
            if t.isGenCode() {
                self.performSegue(withIdentifier: Segue.task_to_gencode, sender: t.code)
            }
            else if self.material.isIAmOwner() {
                self.performSegue(withIdentifier: Segue.material_to_taskdetail, sender: t)
            }
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    func loadData()  {
        //self.showIndicatorDialog()
        WebApi.getMaterialById(id: self.materialId) { (material) in
            guard let mat = material else {
                Util.showAlert(message: "Material is not valid!")
                return
            }
            self.material = mat
            let percent = self.material.getStatusPercent()
            self.viewPercent.startProgress(to: UICircularProgressRing.ProgressValue(percent), duration: 2.0) {
                print("Done animating!")
                // Do anything your heart desires...
            }

            self.imgImage.image = Util.getImage(data64: self.material.image)
            self.lbName.text = self.material.name.uppercased()
            self.lbDate.text = Util.getDate(milisecond: self.material.createdAt, format: Constant.Date_Format)
            self.items.removeAllObjects()
            self.items.addObjects(from: self.material.tasks)
            self.addGenCodeItem()
            self.tableView.reloadData()
            if self.items.count == 0 {
                self.viewDescription.isHidden = false
            }
            //self.dismissIndicatorDialog()
        }
    }
    func addGenCodeItem(){
        let tasks = self.material.tasks;
        if (tasks.count > 0 ){
            var lastTaskFinishded = -1;
            for (index, task) in tasks.enumerated() {
                if (task.isDone()){
                    lastTaskFinishded = index;
                }
            }
            if (lastTaskFinishded > -1){
                let genCode : Task = Task()
                genCode.id = "Gencode_\(self.material.code)"
                genCode.name = "Gen. QR Code"
                genCode.code = self.material.code
                self.items.insert(genCode, at: lastTaskFinishded + 1)
            }
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
            VC.initItem(itemId: "", materialId: self.materialId)
        }
        else if segue.identifier == Segue.material_to_taskdetail {
            let task = sender as! Task
            let VC = segue.destination as! TaskDetailViewController
            VC.initItem(task: task)
        }
        else if segue.identifier == Segue.task_to_gencode {
            let code = sender as! String
            let VC = segue.destination as! TaskGenCodeViewController
            VC.initItem(item: code)
        }
    }
    

}
