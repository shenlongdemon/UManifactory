//
//  SearchProductViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 10/3/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class SearchProductViewController: BaseViewController {

    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        // Do any additional setup after loading the view.
    }
    func loadData() {
        self.showIndicatorDialog()
        items.removeAllObjects()
        WebApi.getCategories { (list) in
            self.dismissIndicatorDialog()
            self.items.addObjects(from: list)
            self.tableView.reloadData()
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    func initTable() {
        let cellIdentifier = CategoryTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : CategoryTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            self.performSegue(withIdentifier: Segue.search_to_product, sender: item)
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.search_to_product {
            let VC = segue.destination as! ProductListViewController
            VC.initItem(cat: sender as! Category)
        }
    }

}
