//
//  DataAceess.swift
//  TimeTracker
//
//  Created by Sergiy Loza on 12.09.17.
//  Copyright © 2017 Sergiy Loza. All rights reserved.
//

import UIKit
import CoreData


let database = DataAceess()

class DataAceess: NSObject {

    func createManager(with firstName:String, and lastName:String) {
        
        let manager = Manager(context: persistentContainer.viewContext)
        manager.firstName = firstName
        manager.lastName = lastName
        saveContext()
    }
    
    func delete(manager: Manager) {
        manager.managedObjectContext?.delete(manager)
    }
    
    func createManagersController() -> NSFetchedResultsController<Manager> {
        let request = Manager.fetchRequest() as NSFetchRequest<Manager>
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Manager.firstName), ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }
    
    func getManagers(callback: @escaping ((_ managers:[Manager]) -> ())) {
        let request = Manager.fetchRequest() as NSFetchRequest<Manager>
        persistentContainer.viewContext.performAndWait {
            do {
                let result = try request.execute()
                callback(result)
            } catch let error as NSError {
                
            }
        }
    }
    
    func managers() -> [Manager] {
        let a = Manager.fetchRequest() as NSFetchRequest<Manager>
        var result = [Manager]()
        persistentContainer.viewContext.performAndWait {
            do {
                result = try a.execute()
            } catch let error as NSError{
                print("error \(error)")
            }
        }
        print("Managers \(result)")
        return result
    }
    
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TimeTracker")
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

extension DataAceess {
    
    func createProject(with name: String, and manager: Manager) {
        let project = Project(context: persistentContainer.viewContext)
        project.name = name
        project.manager = manager
        saveContext()
    }
    
    func createProjectsFetchController() ->  NSFetchedResultsController<Project> {
        let request = Project.fetchRequest() as NSFetchRequest<Project>
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Project.name), ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }
    
    func delete(project: Project) {
        project.managedObjectContext?.delete(project)
    }
}
