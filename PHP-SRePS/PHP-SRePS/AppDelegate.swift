//
//  AppDelegate.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("Running from " + NSBundle.mainBundle().bundlePath);
        
        let deleteEverything = false
//        let deleteEverything = true
        if (deleteEverything == true) {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let docNS = documentsPath as NSString
            
            let dbP1 = docNS.stringByAppendingString("default.realm")
            let dbP2 = docNS.stringByAppendingString("default.realm.lock")
            let dbP3 = docNS.stringByAppendingString("default.realm.note")
            let dbP4 = docNS.stringByAppendingString("default.realm.management")
            
            do{
                try NSFileManager.defaultManager().removeItemAtPath(dbP1)
                try NSFileManager.defaultManager().removeItemAtPath(dbP2)
                try NSFileManager.defaultManager().removeItemAtPath(dbP3)
                try NSFileManager.defaultManager().removeItemAtPath(dbP4)}
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
            exit(0)
        }
        
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let filePathString = url.path! as NSString
        if filePathString.hasSuffix(".phpbk") {
            SalesDataSource.sharedManager.importFromPath(filePathString as String)
        }
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


}

