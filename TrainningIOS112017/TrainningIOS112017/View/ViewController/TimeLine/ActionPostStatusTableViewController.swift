//
//  ActionPostStatusTableViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/29/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class ActionPostStatusTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - IBAction
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        let postStatusVC = self.parent as? TimeLinePostViewController
        postStatusVC?.swipeGestureUp(sender)
    }
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        let postStatusVC = self.parent as? TimeLinePostViewController
        postStatusVC?.swipeGestureDown(sender)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let postStatusVC = self.parent as? TimeLinePostViewController
        postStatusVC?.swipeGestureDown("")
        postStatusVC?.changeAvatar()
    }
}
