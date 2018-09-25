//
//  BaseBluetoothViewController.swift
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

class BaseBluetoothViewController: BaseViewController ,CBCentralManagerDelegate, CBPeripheralDelegate {
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    var devices: NSMutableArray = NSMutableArray()
    let SERVICE : [CBUUID]? = nil //[CBUUID.init()]
    let user = StoreUtil.getUser()!    
    override func viewDidLoad() {
        super.viewDidLoad()
        let opts = [CBCentralManagerOptionShowPowerAlertKey: true]
        manager = CBCentralManager(delegate: self, queue: nil, options: opts)
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
        self.devices.removeAllObjects()
        manager?.scanForPeripherals(withServices: nil, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.stopScanForBLEDevice()
            self.onReceivedBluetooths()
        }
    }
    func onReceivedBluetooths(){
        
    }
    func getBLEDevices() -> [BLEDevice]{
        return self.devices.map({ (d) -> BLEDevice in
            return d as! BLEDevice
        })
    }
    func stopScanForBLEDevice(){
        manager?.stopScan()
        print("scan stopped with \(self.devices.count) devices are founds")
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
        let position = StoreUtil.getPosition()
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


