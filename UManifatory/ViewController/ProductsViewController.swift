//
//  ProductsViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/25/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var items: NSMutableArray = NSMutableArray()
    var tableAdapter:TableAdapter!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        
    }
    @IBAction func goto_CreateProduct(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.add_item, sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData() {
        self.showIndicatorDialog()
        items.removeAllObjects()
        self.tableView.reloadData()
        let user = StoreUtil.getUser()!
        WebApi.getItemsByOwnerId(userId: user.id) { (its) in
            self.items.addObjects(from: its)
            self.tableView.reloadData()
            self.dismissIndicatorDialog()
        }
    }
    func initTable() {
        let cellIdentifier = ProductTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ProductTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
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
