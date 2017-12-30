//
//  AppDelegate.swift
//  TodoLista
//
//  Created by Mac on 12/22/17.
//  Copyright © 2017 shehaboli. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
      
        
        do {
           _ = try Realm()
            
        }
        catch {
            print("Error with declairiing let ream = Realm() \(error)")
        }
        
        
        return true
    }

}
