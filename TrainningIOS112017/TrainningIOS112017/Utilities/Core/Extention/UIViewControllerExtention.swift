//
//  UIViewControllerExtention.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/28/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

extension UIViewController {
    static func loadFromStoryboard(_ storyboardID: StoryboardID) -> UIViewController {
        let identifier = String(describing: self)
        return ApplicationObject.getStoryBoardByID(storyBoardID: storyboardID).instantiateViewController(withIdentifier: identifier)
    }
}
