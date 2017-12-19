//
//  Chatroom+CoreDataProperties.swift
//  
//
//  Created by TuyenVX on 12/19/17.
//
//

import Foundation
import CoreData

extension Chatroom {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chatroom> {
        return NSFetchRequest<Chatroom>(entityName: "Chatroom")
    }

    @NSManaged public var adminID: String?
    @NSManaged public var avatarUrl: String?
    @NSManaged public var descrip: String?
    @NSManaged public var roomID: String?
    @NSManaged public var name: String?

}
