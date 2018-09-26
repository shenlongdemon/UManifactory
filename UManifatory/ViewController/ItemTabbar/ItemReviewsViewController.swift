//
//  ItemReviewsViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/19/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import SafariServices

class ItemReviewsViewController: BaseViewController {

    @IBOutlet weak var viewNoData: UIView!
    var item: Item!
    @IBOutlet weak var tableView: UITableView!
    var items: NSMutableArray = NSMutableArray()
    var tableAdapter:TableAdapter!
    var isViewLoad : Bool = false
    var isItemLoad : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        isViewLoad = true
        self.hideViewNoData()
        //
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideViewNoData()
    }
    func hideViewNoData(){
        if self.isViewLoad == true && self.isItemLoad == true{
            self.tableView.reloadData()
            self.viewNoData.isHidden = self.items.count > 0
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initItem(item: Item) {
        self.item = item
        loadData()
    }
    func initTable() {
        let cellIdentifier = ProductSearchTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ProductSearchTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            //let svc = SFSafariViewController(url: URL(string: (item as! ProductSearch).link)!)
            //self.present(svc, animated: true, completion: nil)
            
        }
        self.tableAdapter.onDidPerformSelectRowAt { (item, type) in
            let i = item as! ProductSearch
            if type == 1{
                if i.reviews.count > 0 {
                    self.performSegue(withIdentifier: "reviewobweb", sender: item)
                }
                else {
                    Util.showAlert(message: "Have no review.")
                }
            }
            else {
                let svc = SFSafariViewController(url: URL(string: i.link)!)
                self.present(svc, animated: true, completion: nil)
            }
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    func loadData() {
        WebApi.getProductSearch(name: self.item.name) { (list) in
            self.items.removeAllObjects()
            self.items.addObjects(from: list)
            self.isItemLoad = true
            self.hideViewNoData()
        }
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
