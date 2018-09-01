//
//  BluetoothDeviceViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/23/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import CoreBluetooth
protocol ChoiceProto {
    func select(device: BLEDevice)
}
class BluetoothDeviceViewController: BaseViewController,CBCentralManagerDelegate, CBPeripheralDelegate  {
    
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
        initTable()
        let opts = [CBCentralManagerOptionShowPowerAlertKey: true]
        manager = CBCentralManager(delegate: self, queue: nil, options: opts)
        progress.stopAnimating()
        // Do any additional setup after loading the view.
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
        manager?.stopScan()
        print("scan stopped with \(self.devices.count) devices are founds")
    }
    func loadData() {
        self.tableView.reloadData()
        self.progress.stopAnimating()
        
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
