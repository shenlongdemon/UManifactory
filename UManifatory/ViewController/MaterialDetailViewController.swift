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
    var tableAdapter:TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    var material : Material!
    var materialId: String!
    var mapView : GMSMapView!
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
        WebApi.getMaterialById(id: self.materialId) { (mat) in
            
            if let material = mat {
                self.material = material
                self.showAllActivities()
                self.navigationController?.navigationBar.topItem?.title = self.material.name
            }
            self.dismissIndicatorDialog()
        }
    }
    func showAllActivities()  {
        self.items.removeAllObjects()
        let activities = self.material.getActivities().sorted { (a1, a2) -> Bool in
            return a1.time > a2.time
        }
        
        self.items.addObjects(from: activities)
        self.tableView.reloadData()
        
        var bounds = GMSCoordinateBounds()
        let path = GMSMutablePath()
        for (_, activity) in activities.enumerated() {
            let coord = activity.coord!
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            path.add(marker.position)
            bounds = bounds.includingCoordinate(marker.position)
            marker.icon = #imageLiteral(resourceName: "white_marker")
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 10.0
        polyline.geodesic = true
        polyline.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        polyline.map = mapView
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initItem(materialId: String){
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
    }
 

}
