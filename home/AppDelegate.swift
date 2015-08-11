//
//  AppDelegate.swift
//  homie
//
//  Created by Zach Silveira on 8/1/15.
//  Copyright © 2015 Zach Silveira. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    let hueLight = [
        13863: 2,
        8601: 3
    ]
    
    var turnedOn = false
    
    var window: UIWindow?
    var enteredRegion = false

    let home = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "home")
    let locationManager = CLLocationManager()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        // Override point for customization after application launch.
        return true
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    let bridgeIP = NSUserDefaults.standardUserDefaults().objectForKey("bridgeIP")!

    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        for beacon in beacons{
            if((hueLight[Int(beacon.major)]) == nil){
                return Notifications.display("There's an Estimote Beacon near you!")
            }
            
            let light = Int(hueLight[Int(beacon.major)]!)
            let url = "http://\(bridgeIP)/api/newdeveloper/lights/\(light)/state"
            
            if(turnedOn == false){
                let parameters = ["on": true]
                Alamofire.request(Method.PUT, url, parameters: parameters, encoding: .JSON)
                
                turnedOn = true
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status{
            
        case .Denied:
            
            let alert = UIAlertController(title: "Warning", message: "You've disabled location update which is required for this app to work. Go to your phone settings and change the permissions.", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(alertAction)
            
            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
        default:
            locationManager.startMonitoringForRegion(home)
            locationManager.requestStateForRegion(home)
            locationManager.startRangingBeaconsInRegion(home)
            
        }
        
    }
    
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        switch state {
            
        case .Unknown:
            print("unknown")
            
        case .Inside:
            print("inside")
            
//            var text : String = "Tap here to start coding."
//            
//            if enteredRegion {
//                text = "Welcome to the best co-working space on the planet."
//            }
//            Notifications.display(text)
            
        case .Outside:
            print("gone")
            turnedOn = false
            let parameters = ["on": false]
            Alamofire.request(Method.PUT, "http://192.168.1.3/api/newdeveloper/groups/0/action", parameters: parameters, encoding: .JSON)
        }
        
    }
    
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("called")
        enteredRegion = true
        turnedOn = false

    }
    
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        enteredRegion = false

    }
    
    
    
    
}

