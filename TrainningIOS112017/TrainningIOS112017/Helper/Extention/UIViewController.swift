//
//  UIViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/27/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

extension UIViewController {
    var mainViewController: MainViewController? {
        if let _mainViewController = self.tabBarController as? MainViewController {
            return _mainViewController
        }
        return view.window?.rootViewController as? MainViewController
    }
}
