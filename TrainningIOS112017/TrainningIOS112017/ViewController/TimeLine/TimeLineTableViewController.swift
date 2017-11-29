//
//  TimeLineTableViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/21/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class TimeLineTableViewController: UITableViewController, TimeLineTableViewCellDelegate, UITextFieldDelegate {
    var postStore: PostStore!
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var searchTextField: UITextField!
    let notificationCentrer = NotificationCenter.default
    var postStatusObserver: NSObjectProtocol?
    //    var timeLineDataSource = TimeLineTableViewDataSource()
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
//        timeLineDataSource = TimeLineTableViewDataSource(tableView: tableView)
//        tableView.dataSource = timeLineDataSource
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    // MARK: - Init
    func setDefaults() {
        tableView.bounces = false
        tableView.register(UINib.init(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeLineTableViewCell")
        tableView.estimatedRowHeight = 377
        // set up search bar
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        searchTextField.delegate = self
//        notificationCentrer.addObserver(forName: .postStatus, object: nil, queue: nil, using: postStatus)
        let mainQueue = OperationQueue.main
        postStatusObserver = notificationCentrer.addObserver(forName: .postStatus, object: nil, queue: mainQueue) { (notification: Notification) in
            guard let userInfo = notification.userInfo, let postItem = userInfo["postItem"] as? PostItem else {
                return
            }
            self.postStore.createPost(newPost: postItem)
            self.tableView.reloadData()
        }
    }
  // MARK: - Deinit
  deinit {
    notificationCentrer.removeObserver(postStatusObserver!)
  }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    // MARK: - UIAction
    @IBAction func postStatus(_ sender: UIButton) {
        let timeLinePostVC = ApplicationObject.getStoryBoardByID(storyBoardID: .timeline).instantiateViewController(withIdentifier: "TimeLinePostViewController") as? TimeLinePostViewController
        present(timeLinePostVC!, animated: true, completion: nil)
    }
    @IBAction func postPhoto(_ sender: UIButton) {
    }
    @IBAction func checkIn(_ sender: UIButton) {
    }
    // MARK: - UITableView Delegate  + Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postStore.allPosts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timeLineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineTableViewCell", for: indexPath) as? TimeLineTableViewCell
        timeLineTableViewCell?.fillData(data: postStore.allPosts[indexPath.row].convertToDictionary())
        timeLineTableViewCell?.delegate = self
        return timeLineTableViewCell!
    }
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    // MARK: - TimelineTableViewCell Delegate
    func comment(index: Int) {
        if let timeLineCommentVC = ApplicationObject.getStoryBoardByID(storyBoardID: .timeline).instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
            timeLineCommentVC.index = index
            timeLineCommentVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(timeLineCommentVC, animated: true)
        }
    }
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
