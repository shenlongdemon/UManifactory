//
//  MyProjectsViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/15/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class MyMaterialsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var items: NSMutableArray = NSMutableArray()
    var tableAdapter:TableAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData() {
        progress.startAnimating()
        items.removeAllObjects()
        self.tableView.reloadData()
        let user = StoreUtil.getUser()!
        WebApi.getMaterialsByOwnerId(ownerId: user.id, pageSize: 10000, pageNum: 1) { (list) in
            self.items.addObjects(from: list)
            self.tableView.reloadData()
            self.progress.stopAnimating()
        }
    }
    func initTable() {
        let cellIdentifier = MaterialTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : MaterialTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            self.performSegue(withIdentifier: Segue.list_to_project, sender: item)
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.list_to_project {
            let material = sender as! Material
            let VC = segue.destination as! MaterialViewController
            VC.initItem(itemId: material.id)
        }
    }
 

}
