//
//  PostItem.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/29/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class PostItem: NSObject {
    var name: String?
    var time: String?
    var status: String?
    var image: UIImage?
    var avatar: UIImage?
    var numberOfLike: Int?
    var numberOfComment: Int?
    var isLiked: Bool
    // MARK: - Init
    override init() {
        isLiked = false
        super .init()
    }
    init(avatar: UIImage, name: String, time: String, status: String, image: UIImage?, numberOfLike: Int, numberOfComment: Int) {
        self.avatar = avatar
        self.name = name
        self.time = time
        self.status = status
        self.image = image
        self.numberOfLike = numberOfLike
        self.numberOfComment = numberOfComment
        isLiked = false
        super.init()
    }
    init(data: [String: Any]) {
        avatar = data[""] as? UIImage ?? UIImage.init()
        name = data[""] as? String
        time = data[""] as? String
        status = data[""] as? String
        image = data[""] as? UIImage
        numberOfLike = (data[""] as? Int)!
        numberOfComment = (data[""] as? Int)!
        if let liked = data["isLiked"] as? Bool {
            isLiked = liked
        } else {
            isLiked = false
        }
    }
    func convertToDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["avatar"] = avatar
        dictionary["name"] = name
        dictionary["time"] = time
        dictionary["status"] = status
        dictionary["image"] = image
        dictionary["numberOfLike"] = numberOfLike
        dictionary["numberOfComment"] = numberOfComment
        dictionary["isLiked"] = isLiked
        return dictionary
    }
    //
    func like() {
        isLiked = !isLiked
    }
}
