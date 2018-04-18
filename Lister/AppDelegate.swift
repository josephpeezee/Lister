//
//  AppDelegate.swift
//  Lister
//
//  Created by Joseph Pizzo on 4/12/18.
//  Copyright © 2018 PEEZEE. All rights reserved.
//

import UIKit

import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //print out path for user defaults
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do {
            _ = try Realm()
//            try realm.write {
//                realm.add(data)
//            }
        } catch {
            print("Error initializing new realm, \(error)")
        }
        
        
        
        return true
    }

    

   

}

