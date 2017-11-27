//
//  SignUpViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/20/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var topConstraint: NSLayoutConstraint!
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var phoneTextField: UITextField!
    @IBOutlet weak private var passWordTextField: UITextField!
    var keyBoardHeigt: CGFloat = 0
    var stackFrame: CGRect = CGRect()
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
        // Dispose of any resources that can be recreated.
    }
    // MARK: - init
    func setDefaults() {
        topConstraint.constant = view.frame.size.height * 0.09
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        passWordTextField.delegate = self
        stackFrame = stackView.frame
    }
    // MARK: -
    override var prefersStatusBarHidden: Bool {
        return true
    }
    // MARK: - UIAction    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func hideKeyBoardTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            phoneTextField.becomeFirstResponder()
        case phoneTextField:
            passWordTextField.becomeFirstResponder()
        case passWordTextField:
            view.endEditing(true)
        default:
            view.endEditing(true)
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        changeViewForKeyBoard(textField: textField)
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
            keyBoardHeigt = keyboardRectangle.height
            var textField = UIView()
            for subview: UIView in stackView.subviews where subview.isFirstResponder == true && subview.isKind(of: UITextField.self) {
                textField = subview
            }
            changeViewForKeyBoard(textField: textField)
        }
    }
    @objc func keyBoardWillHide(_ notification: Notification) {
        UIView.transition(with: view, duration: 2.5, options: .allowAnimatedContent, animations: {
            self.topConstraint.constant = self.view.frame.size.height * 0.09
        }, completion: nil)
    }
    func changeViewForKeyBoard(textField: UIView) {
        let distance = stackFrame.origin.y + textField.frame.size.height + textField.frame.origin.y + keyBoardHeigt + 15  - view.frame.size.height
        if distance > 0 {
            UIView.transition(with: self.view, duration: 2.5, options: .allowAnimatedContent, animations: {
                self.topConstraint.constant =  self.view.frame.size.height * 0.09 - distance
            }, completion: {_ in
                //
            })
        }
    }

}
