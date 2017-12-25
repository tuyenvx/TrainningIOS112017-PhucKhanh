//
//  LaunchViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/23/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet weak private var indicator: UIActivityIndicatorView!
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = UserDefaults.standard.value(forKey: AppKey.token) as? [String: Any] {
            var tokenAPI = AppAPI()
            let param = [
                AppKey.refreshToken: token[AppKey.refreshToken] as Any ,
                AppKey.clientId: "client_id",
                AppKey.clientSecret: "client_secret",
                AppKey.grantType: "refresh_token"
            ]
            tokenAPI.request(httpMethod: .post, param: param, apiType: .token, completionHandle: { (requestResult) in
                switch requestResult {
                case let .success(responseData):
                    UserDefaults.standard.set(responseData[AppKey.token], forKey: AppKey.token)
                    UserDefaults.standard.synchronize()
                    self.gotoMainScreen()
                case .unSuccess:
                    self.gotoLogin()
                case let .failure(error):
                    print(error as Any)
                    self.gotoLogin()
                }
            })
        } else {
            self.gotoLogin()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.startAnimating()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        indicator.stopAnimating()
    }
    // MARK: - UIAction
    func gotoLogin() {
        DispatchQueue.main.async {
            let loginVC = ApplicationObject.getStoryBoardByID(storyBoardID: .login).instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    func gotoMainScreen() {
        DispatchQueue.main.async {
            let timeLineTabbar = ApplicationObject.getStoryBoardByID(storyBoardID: .timeline).instantiateInitialViewController()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate!.window!.rootViewController = timeLineTabbar
        }
    }
}
