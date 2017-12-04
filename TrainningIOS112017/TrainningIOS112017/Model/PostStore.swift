//
//  PostStore.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/29/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import Foundation

class PostStore: NSObject {
    var allPosts: [PostItem] = [PostItem]()
    // MARK: - Init
    override init() {
        let postItem = PostItem(avatar: #imageLiteral(resourceName: "ava_post"), name: "Andrea Kim", time: "2 hrs", status: "so beautiful", image: #imageLiteral(resourceName: "Image"), numberOfLike: 4, numberOfComment: 5)
        for _ in 0...20 {
            allPosts.append(postItem)
        }
        super.init()
    }
    func createPost(newPost: PostItem) {
        allPosts.insert(newPost, at: 0)
    }
}
