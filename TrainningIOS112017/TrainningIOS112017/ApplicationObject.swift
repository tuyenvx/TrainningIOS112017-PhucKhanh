//
//  ApplicationObject.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/20/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//
import UIKit

enum NotificationType {
    case error
    case info
}

enum StoryboardID {
    case login
    case main
    case timeline
    case myPage
}

class ApplicationObject {
    let screenSize = UIScreen.main.bounds
     class func getStoryBoardByID(storyBoardID: StoryboardID) -> UIStoryboard {
        var storyboard = UIStoryboard()
        switch storyBoardID {
        case .login:
            storyboard = UIStoryboard(name: "Login", bundle: nil)
        case .main:
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        case .timeline:
            storyboard = UIStoryboard(name: "Timeline", bundle: nil)
        case .myPage:
            storyboard = UIStoryboard(name: "MyPage", bundle: nil)
        }
        return storyboard
    }
}
