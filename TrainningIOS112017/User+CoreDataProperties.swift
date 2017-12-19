//
//  User+CoreDataProperties.swift
//  
//
//  Created by TuyenVX on 12/19/17.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var userID: String?
    @NSManaged public var username: String?

}
