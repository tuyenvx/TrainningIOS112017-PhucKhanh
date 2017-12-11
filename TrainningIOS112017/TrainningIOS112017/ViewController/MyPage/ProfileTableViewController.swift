//
//  ProfileTableViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/28/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var phoneLabel: UILabel!
    @IBOutlet weak private var birthDayLabel: UILabel!
    let userDefaults = UserDefaults.standard
    var userInfo = [String: Any]()
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
        avatarImageView.image = data["avatar"] as? UIImage
        nameLabel.text = data["name"] as? String
        emailLabel.text = data["email"] as? String
        phoneLabel.text = data["phone"] as? String
        birthDayLabel.text = data["birthDay"] as? String
        addressLabel.text = data["address"] as? String
    }
    // MARK: - IBAction
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfile" {
            let editProfileVC = segue.destination as? EditProfileTableViewController
            editProfileVC?.userInfo = userInfo
        }
    }
}
// MARK: - UITableViewDataSource
extension ProfileTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
}
