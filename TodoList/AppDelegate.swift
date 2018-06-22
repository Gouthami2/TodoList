//
//  AppDelegate.swift
//  TodoList
//
//  Created by Gouthami Reddy on 6/15/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        print(Realm.Configuration.defaultConfiguration.fileURL)
//        let data = Data()
       
        do {
           _ = try Realm()
        } catch {
            print("Error installing realms, \(error)")
        }
        return true
    }
}


