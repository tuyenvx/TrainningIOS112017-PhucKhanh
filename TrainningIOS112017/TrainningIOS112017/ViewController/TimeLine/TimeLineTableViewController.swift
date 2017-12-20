//
//  TimeLineTableViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/21/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class TimeLineTableViewController: BaseTableViewController {
    var postStore: PostStore!
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var searchTextField: UITextField!
    let notificationCentrer = NotificationCenter.default
    var getChatRoomAPI = AppAPI()
    var postStatusObserver: NSObjectProtocol?
    var chatRooms = [[String: Any]]()
    let pageSize = 10
    var currentPage = 0
    var lastIndex = 0
    var total = 0
    //    var timeLineDataSource = TimeLineTableViewDataSource()
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
        getChatRoom(page: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        if let userInfo = ApplicationObject.getUserInfo() {
            avatarImageView.image = userInfo[AppKey.avatar] as? UIImage
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    // MARK: - Init
    func setDefaults() {
        tableView.bounces = false
        tableView.register(UINib.init(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeLineTableViewCell")
        tableView.register(UINib.init(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatRoomTableViewCell")
        tableView.estimatedRowHeight = 45
        // set up search bar
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        searchTextField.delegate = self
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
        let createChatroomNavi = ApplicationObject.getStoryBoardByID(storyBoardID: .timeline).instantiateViewController(withIdentifier: "CreateChatRoomNavi")
        present(createChatroomNavi, animated: true, completion: nil)
    }
    @IBAction func postPhoto(_ sender: UIButton) {
    }
    @IBAction func checkIn(_ sender: UIButton) {
    }
    // MARK: - Action
    func getChatRoom(page: Int) {
        IndicatorManager.showIndicatorView()
        let param = [
            AppKey.page: String(page),
            AppKey.pageSize: String(pageSize)
        ]
        getChatRoomAPI.request(httpMethod: .get, param: param, apiType: .getChatRoom) { (requestResult) in
            IndicatorManager.hideIndicatorView()
            switch requestResult {
            case let .success(responseData):
                guard let pageInfo = responseData[AppKey.pagination] as? [String: Int],
                    let chatRoomList = responseData[AppKey.chatroom] as? [[String: Any]] else {
                        return
                }
                if self.chatRooms.count == self.total {
                    if self.total == pageInfo[AppKey.total]! {
                        return
                    }
                }
                if self.lastIndex != 0 {
                    self.chatRooms = Array(self.chatRooms.prefix(self.chatRooms.count - self.lastIndex))
                }
                self.chatRooms.append(contentsOf: chatRoomList)
                self.updatePageInfo(pageInfo: pageInfo)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .unSuccess(responseData):
                guard let notifiMessage = responseData[AppKey.message] as? String else {
                    return
                }
                self.showNotification(type: .error, message: notifiMessage)
                if responseData[AppKey.code] as? String == "UNAUTHORIZED" {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        self.gotoLogin()
                    })
                }
            case let .failure(error):
                print(error as Any)
                self.showNotification(type: .error, message: "Something went wrong, please try again")
            }
        }
    }
    func updatePageInfo(pageInfo: [String: Int]) {
        currentPage = pageInfo[AppKey.page]!
        lastIndex = pageInfo[AppKey.lastIndex]! % pageSize
        total = pageInfo[AppKey.total]!
    }
    func gotoLogin() {
        DispatchQueue.main.async {
            let loginVC = ApplicationObject.getStoryBoardByID(storyBoardID: .login).instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginVC, animated: true, completion: nil)
        }
    }
}
// MARK: - UITableView DataSource
extension TimeLineTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatRoomCell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomTableViewCell", for: indexPath) as? ChatRoomTableViewCell
        chatRoomCell?.fillData(data: chatRooms[indexPath.row])
        return chatRoomCell!
    }
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
// MARK: - UITableView Delegate
extension TimeLineTableViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == chatRooms.count - 2 && chatRooms.count <= total {
            if lastIndex == 0 {
                currentPage += 1
            }
            getChatRoom(page: currentPage)
        }
    }
}
// MARK: - TimelineTableViewCell Delegate
extension TimeLineTableViewController: TimeLineTableViewCellDelegate {
    func comment(index: Int) {
        print(postStore.allPosts[0])
        if let timeLineCommentVC = ApplicationObject.getStoryBoardByID(storyBoardID: .timeline).instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
            timeLineCommentVC.item = postStore.allPosts[index]
            timeLineCommentVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(timeLineCommentVC, animated: true)
        }
    }
}
// MARK: - UITextField Delegate
extension TimeLineTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
