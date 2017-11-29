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
        let profileNavigationController = ApplicationObject.getStoryBoardByID(storyBoardID: .myPage).instantiateInitialViewController() as? UINavigationController
        let item = UITabBarItem.init(title: " ", image: #imageLiteral(resourceName: "tab_mypage"), selectedImage: #imageLiteral(resourceName: "tab_mypage"))
        profileNavigationController?.tabBarItem = item
        self.viewControllers?.append(profileNavigationController!)
        // make tabbar item in center
        for barItem: UITabBarItem in tabBar.items! {
            barItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
