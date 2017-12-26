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
    var isLoadmore = false
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
        initFooterView()
        tableView.register(UINib.init(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeLineTableViewCell")
        tableView.register(UINib.init(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatRoomTableViewCell")
//        tableView.register(UINib.init(nibName: "LoadMoreTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadMoreTableViewCell")
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
    func initFooterView() {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        footerView.backgroundColor = .white
        let indicatorview = UIActivityIndicatorView.init(frame: CGRect.init(x: footerView.frame.width/2.0 - 20, y: 10, width: 40, height: 40))
        indicatorview.activityIndicatorViewStyle = .gray
        footerView.addSubview(indicatorview)
        indicatorview.startAnimating()
        tableView.tableFooterView = footerView
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
    // MARK: - Action
    func getChatRoom(page: Int) {
        let param = [
            AppKey.page: String(page),
            AppKey.pageSize: String(pageSize)
        ]
        getChatRoomAPI.request(httpMethod: .get, param: param, apiType: .getChatRoom) { (requestResult) in
            switch requestResult {
            case let .success(responseData):
                guard let pageInfo = responseData[AppKey.pagination] as? [String: Int],
                    var chatRoomList = responseData[AppKey.chatroom] as? [[String: Any]] else {
                        self.showLoadMoreCell(isShow: false)
                        return
                }
                if self.chatRooms.count == self.total {
                    if self.total == pageInfo[AppKey.total]! {
                        self.showLoadMoreCell(isShow: false)
                        return
                    }
                }
                chatRoomList = Array(chatRoomList.suffix(from: self.lastIndex))
                // index path của các chatroom mới
                var indexPaths: [IndexPath] = [IndexPath]()
                for row in self.chatRooms.count ..< self.chatRooms.count + chatRoomList.count {
                    let indexPath = IndexPath.init(row: row, section: 0)
                    indexPaths.append(indexPath)
                }
                self.chatRooms.append(contentsOf: chatRoomList)
                self.updatePageInfo(pageInfo: pageInfo)
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: indexPaths, with: .bottom)
                }
                self.showLoadMoreCell(isShow: false)
            case let .unSuccess(responseData):
                self.showLoadMoreCell(isShow: false)
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
                self.showLoadMoreCell(isShow: false)
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
    // MARK: - Load more
    func loadmoreChatroom() {
        showLoadMoreCell(isShow: true)
        if lastIndex == 0 {
            currentPage += 1
        }
        getChatRoom(page: currentPage)
    }
    func showLoadMoreCell(isShow: Bool) {
        DispatchQueue.main.async {
            self.isLoadmore =  isShow
            self.tableView.tableFooterView?.isHidden = !isShow
            self.tableView.contentInset = UIEdgeInsets.init(top: -20, left: 0, bottom: !isShow ? -50 : 0, right: 0)
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
        if indexPath.row == chatRooms.count - 2 && chatRooms.count <= total && isLoadmore == false {
            loadmoreChatroom()
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
// MARK: - TimeLineTableViewController Delegate
extension TimeLineTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y > 100
    }
}
