//
//  UITabbarController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/28/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

extension UITabBarController {
    func makeTabItemInCenter() {
        if let items = tabBar.items {
            for barItem: UITabBarItem in items {
                barItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
    }
}
