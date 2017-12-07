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
        userInfo = ApplicationObject.getUserInfo()!
        fillData(data: userInfo)
    }
    // MARK: - init
    func setDefaults() {
       //
    }
    func fillData(data: [String: Any]) {
        avatarImageView.image = data[AppKey.avatar] as? UIImage
        nameLabel.text = data[AppKey.username] as? String
        emailLabel.text = data[AppKey.email] as? String
        phoneLabel.text = data[AppKey.phone] as? String
        birthDayLabel.text = data[AppKey.birthDay] as? String
        addressLabel.text = data[AppKey.address] as? String
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
        logoutApi.request(httpMethod: .post, param: nil, apiType: .logout) { (data, error) in
            IndicatorManager.hideIndicatorView()
            self.setAllButtonEnable(isEnable: true)
            if let responseData: [String: Any] = data {
                if responseData[AppKey.success] as? Int == 1 {
                    DispatchQueue.main.async {
                        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                        let loginVC = ApplicationObject.getStoryBoardByID(storyBoardID: .login).instantiateViewController(withIdentifier: "LoginViewController")
                        self.present(loginVC, animated: true, completion: nil)
                    }
                } else {
                    guard let errorMessage = responseData[AppKey.message] as? String else {
                        return
                    }
                    self.showNotification(type: .error, message: errorMessage)
                }
            } else {
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
}
// MARK: - UITableViewDataSource
extension ProfileTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
}
