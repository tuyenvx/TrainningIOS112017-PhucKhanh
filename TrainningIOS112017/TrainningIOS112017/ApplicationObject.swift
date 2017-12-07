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
    class func getUserInfo() -> [String: Any]? {
        guard let data = UserDefaults.standard.value(forKey: AppKey.userinfo) as? Data else {
            return nil
        }
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: data)
        return userInfo as? [String: Any]
    }
    class func setUserInfo(userInfo: [String: Any]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        UserDefaults.standard.set(data, forKey: AppKey.userinfo)
        UserDefaults.standard.synchronize()
    }
}
