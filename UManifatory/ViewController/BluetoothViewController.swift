//
//  BluetoothViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/15/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import CoreBluetooth
import SwiftyJSON
protocol ChoiceMaterialProto {
    func selectMaterial(material: Material)
}
class BluetoothViewController: BaseViewController ,CBCentralManagerDelegate, CBPeripheralDelegate {
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    @IBOutlet weak var tableView: UITableView!
    var tableAdapter : TableAdapter!
    var items: NSMutableArray = NSMutableArray()
    var devices: NSMutableArray = NSMutableArray()
    let SERVICE : [CBUUID]? = nil //[CBUUID.init()]
    var user = StoreUtil.getUser()!
    var choiceMaterialProto : ChoiceMaterialProto?
    @IBOutlet weak var progress: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        let opts = [CBCentralManagerOptionShowPowerAlertKey: true]
        manager = CBCentralManager(delegate: self, queue: nil, options: opts)
        progress.stopAnimating()
    }
    func initProto(choiceMaterialProto : ChoiceMaterialProto){
        self.choiceMaterialProto = choiceMaterialProto
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func allProduct(_ sender: Any) {
        self.performSegue(withIdentifier: "allproducts", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //timer?.invalidate()
    }
    func scanBLEDevice(){
        if progress.isAnimating {
            return
        }
        print("start scan")
        progress.startAnimating()
        self.items.removeAllObjects()
        self.devices.removeAllObjects()
        self.tableView.reloadData()
        manager?.scanForPeripherals(withServices: nil, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.stopScanForBLEDevice()
            self.loadData()
        }
        
    }
    func stopScanForBLEDevice(){
        manager?.stopScan()
        print("scan stopped with \(self.devices.count) devices are founds")
    }
    func loadData() {
        self.items.removeAllObjects()
        self.tableView.reloadData()
        self.progress.stopAnimating()
        let testBle : BLEDevice = BLEDevice();
        testBle.id = "1AB3AC95-CFCE-6385-E9E9-E79EDAE8D9CF"
        self.devices.add(testBle)
        if (self.devices.count > 0){
            self.showIndicatorDialog()
            let coord = StoreUtil.getPosition()!.coord!
            WebApi.getMaterialsByBluetooths(bluetooths: self.devices as! [BLEDevice], coord: coord, myId: self.user.id, completion: { (mats) in
                self.dismissIndicatorDialog()
                self.items.addObjects(from: mats)
                self.tableView.reloadData()
            })
        }
    }
    func prepareModel(){
        
    }
    func initTable() {
        let cellIdentifier = MaterialTableViewCell.reuseIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableAdapter = TableAdapter(items:self.items, cellIdentifier: cellIdentifier, cellHeight : MaterialTableViewCell.height)
        self.tableAdapter.onDidSelectRowAt { (item) in
            if let choice = self.choiceMaterialProto {
                self.choiceMaterialProto?.selectMaterial(material: item as! Material)
                self.back()
            }
            else {
                self.performSegue(withIdentifier: Segue.bluetooth_to_material, sender: item)
            }
        }
        self.tableView.delegate = self.tableAdapter
        self.tableView.dataSource = self.tableAdapter
        
    }
    @IBAction func refresh(_ sender: Any) {
        if progress.isAnimating {
            Util.showOKAlert(VC: self, message: "Please wait")
            return
        }
        
        self.scanBLEDevice()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == Segue.bluetooth_to_material) {
            let material = sender as! Material
            let vc = segue.destination as! MaterialViewController
            vc.initItem(itemId: material.id)
        }
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
        bleDevice.ownerId = self.user.id
        if let name = peripheral.name {
            bleDevice.name = name
        }
        //if !hasName {
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
    
}
