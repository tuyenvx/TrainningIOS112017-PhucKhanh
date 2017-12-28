//
//  MainViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/27/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        launch()
    }
    func launch() {
        let launcbVC = LaunchViewController.loadFromStoryboard(.main)
        viewControllers = [launcbVC]
        hideTabbar(hide: true)
    }
    func createTabbar() {
        guard let timelineNavigationController = ApplicationObject.getStoryBoardByID(storyBoardID: .timeline).instantiateInitialViewController() as? UINavigationController else {
            return
        }
        let timeLineTableViewController = timelineNavigationController.viewControllers.first as? TimeLineTableViewController
        let postStore = PostStore()
        timeLineTableViewController!.postStore = postStore
        timelineNavigationController.tabBarItem = tabbarItem(image: #imageLiteral(resourceName: "tab_newFeed"), selectedImage: #imageLiteral(resourceName: "tab_newFeed"))
        guard let profileNavigationController = ApplicationObject.getStoryBoardByID(storyBoardID: .myPage).instantiateInitialViewController() as? UINavigationController else {
            return
        }
        let item = UITabBarItem.init(title: " ", image: #imageLiteral(resourceName: "tab_mypage"), selectedImage: #imageLiteral(resourceName: "tab_mypage"))
        profileNavigationController.tabBarItem = item
        viewControllers = [timelineNavigationController, profileNavigationController]
        makeTabItemInCenter()
        self.selectedIndex = 0
        hideTabbar(hide: false)
    }
    func tabbarItem(image: UIImage, selectedImage: UIImage) -> UITabBarItem {
        return UITabBarItem.init(title: "", image: image, selectedImage: selectedImage)
    }
    func hideTabbar(hide isHidden: Bool) {
        self.tabBar.isHidden = isHidden
    }
}
