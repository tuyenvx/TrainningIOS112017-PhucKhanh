//
//  ChatRoomAvatar.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/26/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import Foundation

class ChatRoomAvatarStore {
    private var avatars = [String]()
    init() {
        avatars = [
            "https://theme.zdassets.com/theme_assets/1051539/ef21e3f955ff543dafc9a1f695a367d7d4f62c33.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Heart_coraz%C3%B3n.svg/1200px-Heart_coraz%C3%B3n.svg.png",
            "https://avatars1.githubusercontent.com/u/2322183?s=280&v=4",
            "https://scontent.fhan2-3.fna.fbcdn.net/v/t1.0-9/10409017_833707476648808_8248022678352459470_n.jpg?oh=0da80c8fac78ed7619ff80ae01fed7b9&oe=5ABC5989",
            "https://cdn.sstatic.net/Sites/stackoverflow/img/apple-touch-icon@2.png?v=73d79a89bded",
            "https:/tinhte.vn/styles/uiflex/dimota/logo.og.png",
            "https://lh3.googleusercontent.com/oKsgcsHtHu_nIkpNd-mNCAyzUD8xo68laRPOfvFuO0hqv6nDXVNNjEMmoiv9tIDgTj8=w170"
        ]
    }
    func getAvatars() -> [String] {
        return avatars
    }
}
