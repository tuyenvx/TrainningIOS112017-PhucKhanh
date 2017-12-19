//
//  UserStore.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/19/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//
import Foundation
import UIKit
import CoreData

@available(iOS 10.0, *)
class UserStore {
    static let context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "TrainningIOS112017")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container.viewContext
    }()
    class func newUser(_ userID: String, _ userName: String, _ email: String ) {
        let user = User(context: context)
        user.userID = userID
        user.username = userName
        user.email = email
        saveContext()
    }
    class func getUser() throws -> [User]? {
        let userFetchRequest: NSFetchRequest = User.fetchRequest()
        return try context.fetch(userFetchRequest)
    }
    class func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
