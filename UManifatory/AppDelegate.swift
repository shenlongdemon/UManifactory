//
//  AppDelegate.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/15/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import CoreLocation
import DropDown
import GoogleMaps
import GooglePlaces

protocol IBeaconAction {
    func onReceive(beacon: CLBeacon)
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()
    var proximityUUIDs: [String] = []
    var beaconRegions: [CLBeaconRegion] = []
    var beaconProto: IBeaconAction?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyCaUN_gPVbw-hTZq6qivI1pHlvQ_7SFT8k")
        GMSPlacesClient.provideAPIKey("AIzaSyCaUN_gPVbw-hTZq6qivI1pHlvQ_7SFT8k")
        self.initLocationManager()
        DropDown.startListeningToKeyboard()
        IQKeyboardManager.shared.enable = true
        //UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0.0, -1000.0), for: .default)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "UManifatory")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
extension AppDelegate :CLLocationManagerDelegate {
    func initLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationObj = locations.last!
        let coordinate = locationObj.coordinate
        let position : Position = Position()
        let coord : Coord = Coord()
        
        coord.latitude = coordinate.latitude
        coord.longitude = coordinate.longitude
        coord.altitude = locationObj.altitude
        
        position.coord = coord
        
        StoreUtil.savePosition(position: position);
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        // let uuid = UUID(uuidString: "\(("FDA50693-A4E2-4FB1-AFCF-C6EB07647825").uppercased())")!
        let uuid = UUID(uuidString: "\(("FDA50123-A4E2-4FB1-AFCF-C6EB07647825").uppercased())")!
        // let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: 1, identifier: "TheBreedBusiness")
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "omid")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for(index, beacon) in beacons.enumerated() {
            if beacon.proximity != .unknown {
                self.beaconProto?.onReceive(beacon: beacon)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        region.identifier
    }
    func updateDistance(_ distance: CLProximity) {
        var a = 10
    }
    func track(bleDevice: BLEDevice) {
        let proUUID = bleDevice.proximityUUID.uppercased()
        if proUUID != "" {
            if !self.proximityUUIDs.contains(proUUID) {
                self.proximityUUIDs.append(proUUID)
                let uuid = UUID(uuidString: proUUID)!
                let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: bleDevice.name)
                locationManager.startMonitoring(for: beaconRegion)
                locationManager.startRangingBeacons(in: beaconRegion)
                self.beaconRegions.append(beaconRegion)
            }
        }
    }
    func stopScanBeacon(){
        for (_, beaconRegion) in self.beaconRegions.enumerated() {
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
            if let index = self.proximityUUIDs.index(of: beaconRegion.proximityUUID.uuidString) {
                self.proximityUUIDs.remove(at: index)
            }
            
            
        }
    }
}
