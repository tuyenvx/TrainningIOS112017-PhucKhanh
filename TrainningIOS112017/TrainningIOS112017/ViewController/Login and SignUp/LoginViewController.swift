//
//  LoginViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/20/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak private var centerVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passWordTextField: UITextField!
    var appApi = AppAPI.init()
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var registerButton: UIButton!
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
        let signupVC = segue.destination as? SignUpViewController
        signupVC?.delegate = self
        self.view.endEditing(true)
    }
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func login(_ sender: Any) {
        setAllButtonEnable(isEnable: false)
        self.view.endEditing(true)
        if emailTextField.text!.count > 6 && passWordTextField.text!.count > 6 {
            var param: Dictionary = [String: String]()
            param[AppKey.username] = emailTextField.text
            param[AppKey.password] = passWordTextField.text
            IndicatorManager.showIndicatorView()
            appApi.requestURLEncoded(httpMethod: .post, param: param, apiType: .login, completionHandle: { (requestResult) in
                IndicatorManager.hideIndicatorView()
                self.setAllButtonEnable(isEnable: true)
                switch requestResult {
                case let .success(responseData):
                    UserDefaults.standard.set(responseData[AppKey.token], forKey: AppKey.token)
                    self.showMainTab()
                case let .unSuccess(responseData):
                    guard let errorMessage = responseData[AppKey.message] as? String else {
                        return
                    }
                    self.showNotification(type: .error, message: errorMessage)
                case let .failure(error):
                    print(error as Any)
                    self.showNotification(type: .error, message: "Can't login, please try again!")
                }
            })
        } else {
            showNotification(type: .error, message: "Email and password must have >6 character")
        }
    }
    func showMainTab() {
        DispatchQueue.main.async {
            var userInfo = ApplicationObject.getUserInfo()
            if userInfo == nil {
                var info: [String: Any] = [String: Any]()
                info[AppKey.username] = self.emailTextField.text
                info[AppKey.avatar] = #imageLiteral(resourceName: "ava_stt")
                info[AppKey.birthDay] = "25/12/1994"
                info[AppKey.address] = "Handico"
                info[AppKey.email] = "irelia@framgia.com"
                info[AppKey.phone] = "0978718305"
                ApplicationObject.setUserInfo(userInfo: info)
            } else {
                userInfo![AppKey.username] = self.emailTextField.text
                ApplicationObject.setUserInfo(userInfo: userInfo!)
            }
            let timeLineTabbar = ApplicationObject.getStoryBoardByID(storyBoardID: .timeline).instantiateInitialViewController()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate!.window!.rootViewController = timeLineTabbar
        }
    }
    func setAllButtonEnable(isEnable: Bool) {
        DispatchQueue.main.async {
            self.loginButton.isEnabled = isEnable
            self.registerButton.isEnabled = isEnable
        }
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
// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passWordTextField.becomeFirstResponder()
        } else {
            login(UIButton())
        }
        return true
    }
}
// MARK: - Signup ViewController Delegate
extension LoginViewController: SignUpViewControllerDelegate {
    func signupSuccess() {
        showNotification(type: .info, message: "RegisterSuccess, please login!")
    }
}
