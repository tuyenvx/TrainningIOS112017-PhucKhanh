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
    class func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
        guard let size = image?.size else {
            return nil
        }
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize.init(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize.init(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image?.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
