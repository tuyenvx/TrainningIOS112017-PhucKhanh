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
        if true {
            let loginVC = ApplicationObject.getStoryBoardByID(storyBoardID: .login).instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginVC, animated: true, completion: nil)
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
}
