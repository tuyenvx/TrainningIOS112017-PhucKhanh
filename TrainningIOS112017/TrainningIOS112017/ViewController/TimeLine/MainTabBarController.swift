//
//  MainTabBarController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/27/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // add tab my page
        if let profileNavigationController = ApplicationObject.getStoryBoardByID(storyBoardID: .myPage).instantiateInitialViewController() as? UINavigationController {
            let item = UITabBarItem.init(title: " ", image: #imageLiteral(resourceName: "tab_mypage"), selectedImage: #imageLiteral(resourceName: "tab_mypage"))
            profileNavigationController.tabBarItem = item
            self.viewControllers?.append(profileNavigationController)
        }
        // make tabbar item in center
        if let items = tabBar.items {
            for barItem: UITabBarItem in items {
                barItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
        //
        let timeLineNavigationController = self.viewControllers?.first as? UINavigationController
        let timeLineTableViewController = timeLineNavigationController?.viewControllers.first as? TimeLineTableViewController
        let postStore = PostStore()
        timeLineTableViewController!.postStore = postStore
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //
    }
}
