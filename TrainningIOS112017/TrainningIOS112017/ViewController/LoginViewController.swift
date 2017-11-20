//
//  LoginViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/20/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passWordTextField: UITextField!
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: -
    override var prefersStatusBarHidden: Bool {
        return true
    }
    // MARK: - init
    func setDefaults() {
        passWordTextField.attributedPlaceholder = NSAttributedString(string: "\u{25CF}\u{25CF}\u{25CF}\u{25CF}\u{25CF}\u{25CF}", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    // MARK: - UIAction
    @IBAction func login(_ sender: Any) {
        if emailTextField.text!.count > 6 && passWordTextField.text!.count > 6 {
            // login
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                print("Khong the login")
                return
            }
            appDelegate.showMainTab()
        }
    }
}
