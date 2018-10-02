//
//  BluetoothProductAroundViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 9/22/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import CoreBluetooth
import GoogleMaps
import GooglePlaces
import SwiftyJSON
class BluetoothProductAroundViewController: BaseBluetoothViewController {
    @IBOutlet weak var progress: UIActivityIndicatorView!
    // begin-table
    @IBOutlet weak var tableView: UITableView!
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    var markerDict : Dictionary = [String: GMSMarker]()
    // end-table
    
    // begin-map
    @IBOutlet weak var mapUIView: UIView!
    var mapView : GMSMapView!
    // end-map
    
    // begin-flag
    var isTracking : Bool = false
    // end-flag
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        initMap()
        Util.getAppDelegate()?.beaconProto = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isTracking = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isTracking = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func onStartScanBluetooths() {
        self.progress.startAnimating()
    }
    override func onReceivedBluetooths() {
        self.progress.stopAnimating()
        let devices = self.getBLEDevices()
        // because they have no proximityUUID - it means because we just scan bluetooth
        let bluetoothIds = devices.map { (ble) -> String in
            return ble.id
        }
        
        WebApi.getProductsByBluetoothIds(bluetoothIds: bluetoothIds) { (items) in
            self.items.removeAllObjects()
            self.items.addObjects(from: items)
            self.tableView.reloadData()
            
            for (_, item) in items.enumerated(){
                let proximity = item.iBeacon?.proximityUUID ?? ""
                if proximity != "" {
                    Util.getAppDelegate()?.track(bleDevice: item.iBeacon!)
                }
            }
        }
    }
    func initTable() {
        let cellIdentifier = ProductTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : ProductTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            self.performSegue(withIdentifier: Segue.bluetooth_around_to_product, sender: item)
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.bluetooth_around_to_product {
            let item = sender as! Item
            let VC = segue.destination as! ProductTabBarViewController
            VC.initItem(item: item)
        }
    }
    
    
}

extension BluetoothProductAroundViewController: IBeaconAction {
    func onReceive(beacon: CLBeacon) {
        if self.isTracking {
            DispatchQueue.main.async{
                self.calculateBeaconPosition(beacon: beacon)
            }
        }
    }
    
    func calculateBeaconPosition(beacon: CLBeacon){
        let proximityId: String = beacon.proximityUUID.uuidString
        let distance = Util.getDistance(beacon: beacon, currentPosition: StoreUtil.getPosition())
        guard let item = self.items.first(where: { (i) -> Bool in
            let item: Item = i as! Item
            return (item.iBeacon?.proximityUUID.uppercased() ?? "") == proximityId
        }) as? Item else {
            return
        }
        print("\(beacon)  \(distance)")
      
        
        WebApi.uploadBeaconLocation(itemId: item.id, proximityId: proximityId, position: StoreUtil.getPosition()!, distance: distance, userId: StoreUtil.getUser()!.id){ (i) in
            
            if let item = i {
                let key = item.iBeacon?.proximityUUID ?? "unknow"
                var marker : GMSMarker!
                if  !self.markerDict.keys.contains(key) {
                    marker = GMSMarker()
                    marker.title = item.name
                    marker.map = self.mapView
                    self.markerDict[key] = marker
                }
                else {
                    marker = self.markerDict[key]!
                    
                }
                if let iBeacon = item.iBeacon {
                    marker.position = CLLocationCoordinate2D(latitude: iBeacon.coord.latitude, longitude: iBeacon.coord.longitude)
                }
                else {
                    marker.map = nil
                }
            }
        }
    }
}

extension BluetoothProductAroundViewController : GMSMapViewDelegate {
    
    func initMap(){
        mapView = GMSMapView(frame: self.mapUIView.bounds)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        let pos = StoreUtil.getPosition()!
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: pos.coord.latitude, longitude: pos.coord.longitude), zoom: kGMSMaxZoomLevel, bearing: mapView.camera.bearing, viewingAngle:  mapView.camera.viewingAngle)
        
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
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        if let title = overlay.title {
            Util.showAlert(message: title )
        }
    }
}

