//
//  MaterialDetailViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/27/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MaterialDetailViewController: BaseViewController, GMSMapViewDelegate  {

    @IBOutlet weak var mapUIView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddMaintain: UIButton!
    
    var tableAdapter:TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    var material : Material?
    var materialId: String!
    var itemId: String!
    var item : Item?
    var mapView : GMSMapView!
    let user = StoreUtil.getUser()!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        // Do any additional setup after loading the view.
        initMap()
    }
    func initMap(){
        mapView = GMSMapView(frame: self.mapUIView.bounds)
        mapView.isMyLocationEnabled = false
        mapView.delegate = self
       
        
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
    @IBAction func addActivity(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.material_detail_to_add_activity, sender: nil)
    }
    
    func initTable() {
        let cellIdentifier = ActivityTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ActivityTableViewCell.height)
        
        self.tableAdapter.onDidSelectRowAt { (item) in
            self.performSegue(withIdentifier: Segue.materialdetail_to_activitydetail, sender: item)
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    func loadData(){
        
        self.showIndicatorDialog()
        
        if self.itemId != "" {
            WebApi.getItemById(id: self.itemId, completion: { (it) in
                if let i = it {
                    self.item = i
                    if self.item?.owner.id != self.user.id {
                        self.btnAddMaintain.isHidden = true
                    }
                }
                
                self.dismissIndicatorDialog()
                self.showAllActivities()
                
            })
        }
        else {
            WebApi.getMaterialById(id: self.materialId) { (mat) in
                if let material = mat {
                    self.material = material
                }
                
                self.dismissIndicatorDialog()
                self.showAllActivities()
            
            }
        }
    }
    func showAllActivities()  {
        self.items.removeAllObjects()
        if self.itemId != "" {
            let maintainceActivity: [Activity] = self.item?.maintains.sorted { (a1, a2) -> Bool in
                return a1.time > a2.time
                } ?? []
            self.items.addObjects(from: maintainceActivity)
        }
        else {
            let activities = self.material?.getActivities().sorted { (a1, a2) -> Bool in
                return a1.time > a2.time
                } ?? []
            self.items.addObjects(from: activities)
        }
        self.tableView.reloadData()
        
        var bounds = GMSCoordinateBounds()
        let path = GMSMutablePath()
        for (_, act) in self.items.enumerated() {
            let activity = act as! Activity
            let coord = activity.coord!
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
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50.0 , 50.0 ,50.0 ,50.0)))
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initItem(itemId: String, materialId: String){
        self.itemId = itemId
        self.materialId = materialId
    }
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        if let title = overlay.title {
            Util.showAlert(message: title )
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.materialdetail_to_activitydetail {
            let activity = sender as! Activity
            let VC = segue.destination as! ActivityDetailViewController
            VC.initItem(item: activity)
        }
        else if segue.identifier == Segue.material_detail_to_add_activity {
            let workerId = StoreUtil.getUser()!.id
            let VC = segue.destination as! ActivityViewController
            VC.initData(itemId: self.itemId ,materialId: self.materialId, taskId: UUID.init().uuidString, workerId: workerId)
        }
    }
 

}
