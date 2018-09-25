//
//  ItemAttachFilesViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/19/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import SafariServices
class ItemAttachFilesViewController: BaseViewController {
    var item: Item!
    @IBOutlet weak var tableView: UITableView!
    var items: NSMutableArray = NSMutableArray()
    var tableAdapter:TableAdapter!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func initItem(item: Item){
        self.item = item
        
        self.items.removeAllObjects()
        let pdfFiles = self.item.material?.getPDFFiles() ?? []
        self.items.addObjects(from: pdfFiles)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTable() {
        let cellIdentifier = PDTFilesTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : PDTFilesTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            let link = "\(WebApi.HOST)/uploads/\(item.getId())"
            let svc = SFSafariViewController(url: URL(string: link)!)
            self.present(svc, animated: true, completion: nil)
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
