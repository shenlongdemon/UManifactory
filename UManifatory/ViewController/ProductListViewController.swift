//
//  ProductListViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 10/3/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class ProductListViewController: BaseViewController {
    var category: Category!
    @IBOutlet weak var collectionView: UICollectionView!
    var items: NSMutableArray = NSMutableArray()
    var collectionAdapter: CollectionAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollection()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    func initCollection() {
        
        let cellIdentifier = ProductCollectionViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        
        self.collectionAdapter = CollectionAdapter(items:self.items, cellIdentifier: cellIdentifier,itemPerRow: 2, cellHeight : ProductCollectionViewCell.height)
        
        self.collectionAdapter.onDidSelectRowAt { (item) in
            self.performSegue(withIdentifier: Segue.productsearch_to_detail, sender: item)
        }
        
        self.collectionView.delegate = self.collectionAdapter
        self.collectionView.dataSource = self.collectionAdapter
        
    }
    
    func loadData() {
        self.showIndicatorDialog()
        items.removeAllObjects()
        WebApi.getProductsByCategory(categoryId: self.category.id) { (list) in
            self.dismissIndicatorDialog()
            self.items.addObjects(from: list)
            //self.tableView.reloadData()
            self.collectionView.reloadData()
            
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.productsearch_to_detail {
            let item = sender as! Item
            let VC = segue.destination as! ProductTabBarViewController
            VC.initItem(item: item)
        }
    }
    
    func initItem(cat: Category){
        self.category = cat
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
