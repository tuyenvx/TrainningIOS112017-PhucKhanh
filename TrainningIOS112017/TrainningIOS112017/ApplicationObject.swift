//
//  ApplicationObject.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/20/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//
import UIKit

enum StoryboardID {
    case login
    case main
}

class ApplicationObject {
     class func getStoryBoardByID(storyBoardID: StoryboardID) -> UIStoryboard {
        var storyboard = UIStoryboard()
        switch storyBoardID {
        case .login:
            storyboard = UIStoryboard(name: "Login", bundle: nil)
        case .main:
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
        return storyboard
    }
}
