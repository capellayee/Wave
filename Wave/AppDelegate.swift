//
//  AppDelegate.swift
//  Wave
//
//  Created by Capella Yee on 1/5/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // helper debug code to figure out what schema version i'm on.
        let configCheck = Realm.Configuration();
        do {
            let fileUrlIs = try schemaVersionAtURL(configCheck.fileURL!)
            print("schema version \(fileUrlIs)")
        } catch  {
            print(error)
        }
        
        let config = Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 4) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Class object stored in the Realm file
                    migration.enumerateObjects(ofType: Category.className()) { oldObject, newObject in
                        let color = UIColor.randomFlat.hexValue()
                        newObject!["backgroundColor"] = color
                        print("hey!, added a new background color \(color)")
                    }

                }
        })
    
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    // lazy keyword: only loads up a value when it's needed. only occupyin memory when it's needed
    lazy var persistentContainer: NSPersistentContainer = {
        // this is basically a sqllite database
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

