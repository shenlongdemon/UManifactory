//
//  TaskDetailViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/16/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import UICircularProgressRing
import ImageSlideshow
import SafariServices
class TaskDetailViewController: BaseViewController {
    
    @IBOutlet weak var btnWorkerNo: BaseButton!
    @IBOutlet weak var imgImage: BaseImage!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnDone: BaseButton!
    @IBOutlet weak var viewPercent: UICircularProgressRing!
    var task: Task!
    
    @IBOutlet weak var imgWorker: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var items: NSMutableArray = NSMutableArray()
    var tableAdapter:TableAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToAssignWorker(tapGestureRecognizer:)))
        self.imgWorker.isUserInteractionEnabled = true
        self.imgWorker.addGestureRecognizer(tapGestureRecognizer)
        initTable()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.lbName.text = self.task.name.uppercased()
        self.task.getImage { (img) in
            self.imgImage.image = img
        }        
        self.btnDone.setTitle("Close \(self.task.name.capitalized(with: Locale.current)) Step", for: .normal)
        loadData()
    }
    @objc func goToAssignWorker(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: Segue.material_to_assignworker, sender: self)
    }
    func loadData()  {
        
        WebApi.getTaskById(materialId: self.task.materialId, taskId: self.task.id) { (task) in
            guard let t = task else {
                Util.showAlert(message: "Block is not valid!")
                return
            }
            self.task.workers = t.workers
            let percent = self.task.getStatusPercent()
            self.viewPercent.startProgress(to: UICircularProgressRing.ProgressValue(percent), duration: 2.0) {
                print("Done animating!")
                // Do anything your heart desires...
            }
            let activities: [Activity] = self.task.getActivities().reversed()
            self.items.removeAllObjects()
            self.items.addObjects(from: activities)
            self.tableView.reloadData()
            
            self.btnWorkerNo.setTitle("\(self.task.workers.count)", for: .normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneTask(_ sender: Any) {
        self.showIndicatorDialog()
        Util.getUesrInfo { (ui) in
            guard let userInfo = ui else {
                self.dismissIndicatorDialog()
                return
            }
            WebApi.finishTask(materialId: self.task.materialId, taskId: self.task.id, taskName: self.task.name, userInfo: userInfo, completion: { (done) in
                self.dismissIndicatorDialog()
                if done {
                    self.back()
                }
            })
        }
    }
    
    
    func initItem(task: Task){
        self.task = task
    }
    func initTable() {
        let cellIdentifier = ActivityTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ActivityTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            self.performSegue(withIdentifier: Segue.taskdetail_to_activitydetail, sender: item)
//            let link = "\(WebApi.HOST)/uploads/\(item.getId())"
//            let svc = SFSafariViewController(url: URL(string: link)!)
//            self.present(svc, animated: true, completion: nil)
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Segue.material_to_assignworker {
            let VC = segue.destination as! AssignWotkerViewController
            VC.initData(materialId: self.task.materialId, taskId: self.task.id)
        }
        else if segue.identifier == Segue.taskdetail_to_activitydetail {
            let activity = sender as! Activity
            let VC = segue.destination as! ActivityDetailViewController
            VC.initItem(item: activity)
        }
    }
    

}
