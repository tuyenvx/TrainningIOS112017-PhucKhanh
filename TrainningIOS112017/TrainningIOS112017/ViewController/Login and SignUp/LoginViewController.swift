//
//  LoginViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/20/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak private var centerVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passWordTextField: UITextField!
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyBoardNotifi()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyBoardNotifi()
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
        passWordTextField.attributedPlaceholder = NSAttributedString(string: "\u{2981}\u{2981}\u{2981}\u{2981}\u{2981}\u{2981}", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passWordTextField.delegate = self
        emailTextField.delegate = self
    }
    // MARK: - UIAction
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.view.endEditing(true)
    }
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func login(_ sender: Any) {
        self.view.endEditing(true)
        if emailTextField.text!.count > 6 && passWordTextField.text!.count > 6 {
            showMainTab()
        } else {
            showNotification(type: .error, message: "Email and password must have >6 character")
        }
    }
    func showMainTab() {
        let timeLineTabbar = ApplicationObject.getStoryBoardByID(storyBoardID: .timeline).instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate!.window!.rootViewController = timeLineTabbar
    }
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passWordTextField.becomeFirstResponder()
        } else {
            login(UIButton())
        }
        return true
    }
    // MARK: - Keyboard
    func addKeyBoardNotifi() {
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver( self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func removeKeyBoardNotifi() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let distance = keyboardHeight + 150 - self.view.frame.size.height/2.0 // 150 = 300/2 (view height / 2)
            if distance > 0 {
                UIView.transition(with: view, duration: 2.5, options: .allowAnimatedContent, animations: {
                    self.centerVerticalConstraint.constant = -distance
                }, completion: {_ in
                    //
                })
            }
        }
    }
    @objc func keyBoardWillHide(_ notification: Notification) {
        UIView.transition(with: view, duration: 2.5, options: .allowAnimatedContent, animations: {
            self.centerVerticalConstraint.constant = 0
        }, completion: nil)
    }
}
