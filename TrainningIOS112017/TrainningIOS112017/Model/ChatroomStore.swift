//
//  ChatroomStore.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/19/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@available(iOS 10.0, *)
class ChatroomStore {
    static let context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "TrainningIOS112017")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container.viewContext
    }()
    class func newChatroom(_ chatroomId: String, _ adminID: String, _ name: String, description: String, _ avatarUrl: String? ) {
        let chatroom = Chatroom(context: context)
        chatroom.roomID = chatroomId
        chatroom.adminID = adminID
        chatroom.name = name
        chatroom.descrip = description
        chatroom.avatarUrl = avatarUrl
    }
    class func getChatroom() throws -> [Chatroom]? {
        let chatroomFetchRequest: NSFetchRequest = Chatroom.fetchRequest()
        return try context.fetch(chatroomFetchRequest)
    }
    class func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
