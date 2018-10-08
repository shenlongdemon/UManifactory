//
//  BluetoothDeviceViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/23/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import CoreBluetooth
import GoogleMaps
import GooglePlaces
protocol ChoiceProto {
    func select(device: BLEDevice)
}
class BluetoothDeviceViewController: BaseViewController,CBCentralManagerDelegate, CBPeripheralDelegate, GMSMapViewDelegate   {
    
    @IBOutlet weak var mapUIView: UIView!
    var mapView : GMSMapView!
    
    @IBOutlet weak var tableView: UITableView!
    let user = StoreUtil.getUser()!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    let SERVICE : [CBUUID]? = nil //[CBUUID.init()]
    var devices: NSMutableArray = NSMutableArray()
    var tableAdapter : TableAdapter!
    var choiceProto : ChoiceProto?
    override func viewDidLoad() {
        super.viewDidLoad()
        initMap()
        initTable()
        let opts = [CBCentralManagerOptionShowPowerAlertKey: true]
        manager = CBCentralManager(delegate: self, queue: nil, options: opts)
        progress.stopAnimating()
        // Do any additional setup after loading the view.
    }
    @IBAction func refresh(_ sender: Any) {
        if !self.progress.isAnimating {
            self.scanBLEDevice()
        }
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
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        if let title = overlay.title {
            Util.showAlert(message: title )
        }
    }
    func initTable() {
        let cellIdentifier = BLEDeviceTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.devices, cellIdentifier: cellIdentifier, cellHeight : BLEDeviceTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            self.choiceProto?.select(device: item as! BLEDevice)
            self.back()
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    func scanBLEDevice(){
        print("start scan")
        progress.startAnimating()
        self.devices.removeAllObjects()
        self.tableView.reloadData()
        manager?.scanForPeripherals(withServices: nil, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.stopScanForBLEDevice()
            self.loadData()
        }
        
    }
    func stopScanForBLEDevice(){
        self.progress.stopAnimating()
        manager?.stopScan()
        print("scan stopped with \(self.devices.count) devices are founds")
    }
    func loadData() {
        guard self.devices.count > 0 else {
            return
        }
        self.showIndicatorDialog()
        let bluetoothIds = self.devices.map { (bleDevice) -> String in
            let ble = bleDevice as! BLEDevice
            return ble.id
        }

        WebApi.getBeaconsByBluetoothIds(bluetoothIds: bluetoothIds) { (beacons) in
            
            for (_, bleDevice) in self.devices.enumerated() {
                let ble = bleDevice as! BLEDevice
                let beacon = beacons.first(where: { (bleBeacon) -> Bool in
                    return bleBeacon.bluetoothId.uppercased() == ble.id.uppercased()
                })
                ble.proximityUUID = beacon?.beaconId ?? ""
            }
            self.dismissIndicatorDialog()
            self.tableView.reloadData()
        }
        
        
        
        
    }
    func initItem(choiceProto : ChoiceProto){
        self.choiceProto = choiceProto
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch(central.state){
        case .poweredOn:
            print("Bluetooth is powered ON")
        case .poweredOff:
            print("Bluetooth is powered OFF")
        case .resetting:
            print("Bluetooth is resetting")
        case .unauthorized:
            print("Bluetooth is unauthorized")
        case .unknown:
            print("Bluetooth is unknown")
        case .unsupported:
            print("Bluetooth is not supported")
        }
        if central.state == .poweredOn {
            self.scanBLEDevice()
        } else {
            Util.showOKAlert(VC: self, message: "Please turn on Bluetooth")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let bleDevice = BLEDevice()
        
        bleDevice.id = peripheral.identifier.uuidString
        if let name = peripheral.name {
            bleDevice.name = name
        }
        
        if let device = (advertisementData as NSDictionary) .object(forKey: CBAdvertisementDataLocalNameKey) as? NSString {
            bleDevice.name = device as String
        }
        var position = StoreUtil.getPosition()
        let coord = position!.toBLEPosition().coord!
        coord.distance = Util.getBLEBeaconDistance(RSSI: RSSI)
        bleDevice.coord = coord
        bleDevice.ownerId = self.user.id
        if !self.devices.map({ (device) -> String in
            return (device as! BLEDevice).id
        }).contains(bleDevice.id) {
            self.devices.add(bleDevice)
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
