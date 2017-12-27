//
//  ProfileTableViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/28/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var phoneLabel: UILabel!
    @IBOutlet weak private var birthDayLabel: UILabel!
    let userDefaults = UserDefaults.standard
    var userInfo = [String: Any]()
    var logoutApi = AppAPI()
    @IBOutlet weak private var logoutButton: UIButton!
    @IBOutlet weak private var editProfileBarButtonItem: UIBarButtonItem!

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userInfo = ApplicationObject.getUserInfo() {
            fillData(data: userInfo)
        } else {
            getUserInfo()
        }
    }
    // MARK: - init
    func setDefaults() {
       //
    }
    func fillData(data: [String: Any]) {
        DispatchQueue.main.async {
            self.avatarImageView.image = data[AppKey.avatar] as? UIImage
            self.nameLabel.text = data[AppKey.username] as? String
            self.emailLabel.text = data[AppKey.email] as? String
            self.phoneLabel.text = data[AppKey.phone] as? String
            self.birthDayLabel.text = data[AppKey.birthDay] as? String
            self.addressLabel.text = data[AppKey.address] as? String
        }
    }
    // MARK: - IBAction
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfile" {
            let editProfileVC = segue.destination as? EditProfileTableViewController
            editProfileVC?.userInfo = userInfo
        }
    }
    @IBAction func logout(_ sender: Any) {
        setAllButtonEnable(isEnable: false)
        IndicatorManager.showIndicatorView()
        logoutApi.request(httpMethod: .post, param: nil, apiType: .logout) { (requestResult) in
            IndicatorManager.hideIndicatorView()
            self.setAllButtonEnable(isEnable: true)
            switch requestResult {
            case .success:
                DispatchQueue.main.async {
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    UserDefaults.standard.synchronize()
                    let loginVC = ApplicationObject.getStoryBoardByID(storyBoardID: .login).instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(loginVC, animated: true, completion: nil)
                }
            case let .unSuccess(responseData):
                guard let errorMessage = responseData[AppKey.message] as? String else {
                    return
                }
                self.showNotification(type: .error, message: errorMessage)
            case let .failure(error):
                self.showNotification(type: .error, message: "Some thing went wrong, please try again later")
                print(error as Any)
            }
        }
    }
    // MARK: - Action
    func setAllButtonEnable(isEnable: Bool) {
        DispatchQueue.main.async {
            self.logoutButton.isEnabled = isEnable
            self.editProfileBarButtonItem.isEnabled = isEnable
        }
    }
    func getUserInfo() {
        var getUserInfoApi = AppAPI()
        getUserInfoApi.request(httpMethod: .get, param: nil, apiType: .userInfo) { (requestResult) in
            switch requestResult {
            case let .success(responseData):
                guard var userInfo = responseData["user"] as? [String: Any] else {
                    return
                }
                userInfo[AppKey.avatar] = #imageLiteral(resourceName: "ava_stt")
                userInfo[AppKey.birthDay] = "25/12/1994"
                userInfo[AppKey.address] = "Handico"
                userInfo[AppKey.phone] = "0978718305"
                ApplicationObject.setUserInfo(userInfo: userInfo)
                self.fillData(data: userInfo)
            case let .unSuccess(responseData):
                guard let errorMessage = responseData[AppKey.message] as? String else {
                    return
                }
                self.showNotification(type: .error, message: errorMessage)
            case .failure:
                self.showNotification(type: .error, message: "Can't load user infomation")
            }
        }
    }
}
// MARK: - UITableViewDataSource
extension ProfileTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
}
