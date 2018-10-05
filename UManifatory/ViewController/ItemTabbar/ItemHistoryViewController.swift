//
//  ItemHistoryViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/19/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class ItemHistoryViewController: BaseViewController {

    @IBOutlet weak var mapUIView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var tableAdapter:TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    var item : Item!    
    var mapView : GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initMap()
        initTable()
        loadHistoryData()
        // Do any additional setup after loading the view.
    }
    func initMap(){
        mapView = GMSMapView(frame: self.mapUIView.bounds)
        mapView.isMyLocationEnabled = false
        
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude), zoom: kGMSMinZoomLevel, bearing: mapView.camera.bearing, viewingAngle:  mapView.camera.viewingAngle)
        
        mapView.camera = camera
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        self.mapUIView.addSubview(mapView)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initItem(item:Item){
        self.item = item
    }
    func initTable() {
        let cellIdentifier = ItemHistoryTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ItemHistoryTableViewCell.height)
        
        self.tableAdapter.onDidSelectRowAt { (item) in
            let itemHistory = item as! ItemHistory
            // if it has activity then show activity detail
            if let activity = itemHistory.activity {
                self.performSegue(withIdentifier: Segue.itemhistory_to_activitydetail, sender: activity)
            }
            // or show code of history
            else {
                self.performSegue(withIdentifier: Segue.itemhistory_to_code, sender: itemHistory)
            }
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    func loadHistoryData()  {
        //self.showIndicatorDialog()
        WebApi.getItemById(id: self.item.id) { (i) in
            guard let it = i else {
                Util.showAlert(message: "Product is not valid!")
                return
            }
            self.item = it
            self.showAllHistories()
        }
    }
    
    func showAllHistories()  {
        self.items.removeAllObjects()        
        let actions = self.item.section.history.reversed()
        for (index, history) in actions.enumerated() {
            if index < actions.count - 1 {
                let action = ItemHistory(location: history.position.coord, name: "BUY", code: history.code, time: history.time, imageUrl: history.imageUrl,  activity: nil)
                self.items.add(action)
            }
        }
        let package = self.item.section.history[0]
        let packaging = ItemHistory(location: package.position.coord, name: "PACKAGING",code: package.code, time: package.time, imageUrl: self.item.imageUrl,  activity: nil)
        self.items.add(packaging)
        
        let tasks = (self.item.material?.tasks ?? []).reversed().flatMap { (task) -> [ItemHistory] in
            
            let activities = task.getActivities().reversed().map({ (activity) -> ItemHistory in                
                return ItemHistory(location: activity.coord, name: activity.title, code: "", time: activity.time, imageUrl: task.imageUrl, activity: activity)
            })
            return activities
        }
        self.items.addObjects(from: tasks)
        
        self.tableView.reloadData()
        
        var bounds = GMSCoordinateBounds()
        let path = GMSMutablePath()
        for (_, item) in self.items.enumerated() {
            let history = item as! ItemHistory
            let coord = history.location
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            
            bounds = bounds.includingCoordinate(marker.position)
            marker.icon =  #imageLiteral(resourceName: "white_marker")
            marker.map = self.mapView
            
            path.add(marker.position)
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 1.0
        polyline.geodesic = true
        polyline.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        polyline.map = self.mapView
        
        if self.items.count > 0 {
            mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50.0 , 50.0 ,50.0 ,50.0)))
        }
        else {
            
            mapView.animate(with: GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: packaging.location.latitude, longitude: packaging.location.longitude), zoom: kGMSMinZoomLevel))
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Segue.itemhistory_to_activitydetail {
            let item = sender as! Activity
            let VC = segue.destination as! ActivityDetailViewController
            VC.initItem(item: item)
        }
        else if segue.identifier == Segue.itemhistory_to_code {
            let itemHistory = sender as! ItemHistory
            let VC = segue.destination as! TaskGenCodeViewController
            VC.initItem(code: itemHistory.code, time: itemHistory.time, logoUrl: itemHistory.imageUrl ?? "")
        }
    }
    

}
