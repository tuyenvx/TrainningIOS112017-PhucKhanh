//
//  TimeLineTableViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/21/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class TimeLineTableViewController: UITableViewController, TimeLineTableViewCellDelegate {
    @IBOutlet weak private var avatarImageView: UIImageView!
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Init
    func setDefaults() {
        tableView.bounces = false
        tableView.register(UINib.init(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeLineTableViewCell")
        tableView.estimatedRowHeight = 377
        // set up search bar
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    // MARK: - UIAction
    @IBAction func postStatus(_ sender: UIButton) {
        let timeLinePostVC = ApplicationObject.getStoryBoardByID(storyBoardID: .timeline).instantiateViewController(withIdentifier: "TimeLinePostViewController")
        present(timeLinePostVC, animated: true, completion: nil)
    }
    @IBAction func postPhoto(_ sender: UIButton) {
    }
    @IBAction func checkIn(_ sender: UIButton) {
    }
    // MARK: - UITableView Delegate  + Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timeLineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineTableViewCell", for: indexPath) as? TimeLineTableViewCell
        if indexPath.row == 1 {
            timeLineTableViewCell?.setStatus(status: "Error is straight forward and its because of wrong placeholders you have used in function call. Inside init you are not passing any parameters to your function. It should be this way")
        } else if indexPath.row == 5 {
            timeLineTableViewCell?.setStatus(status: "Error is straight forward and its because of wrong placeholders you have used in function call")
        } else {
            timeLineTableViewCell?.setStatus(status: "Interesting study")
        }
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
}
