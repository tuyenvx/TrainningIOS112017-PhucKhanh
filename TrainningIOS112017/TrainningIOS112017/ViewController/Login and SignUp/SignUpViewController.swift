//
//  SignUpViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/20/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var topConstraint: NSLayoutConstraint!
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var phoneTextField: UITextField!
    @IBOutlet weak private var passWordTextField: UITextField!
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var addPhotoLabel: UILabel!
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
    // MARK: - IBAction
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func hideKeyBoardTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func addPhoto(_ sender: UIButton) {
        let chosePhotoAlertViewController = UIAlertController.init(title: "Application", message: "Take avatar from :", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction.init(title: "Camera", style: .default) { _ in
            self.showImagePicker(sourceType: .camera)
        }
        let libraryAction = UIAlertAction.init(title: "Library", style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        let saveAlbulmAction = UIAlertAction.init(title: "Album", style: .default) { _ in
            self.showImagePicker(sourceType: .savedPhotosAlbum)
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            chosePhotoAlertViewController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            chosePhotoAlertViewController.addAction(libraryAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            chosePhotoAlertViewController.addAction(saveAlbulmAction)
        }
        chosePhotoAlertViewController.addAction(cancelAction)
        present(chosePhotoAlertViewController, animated: true, completion: nil)
    }
    @IBAction func register(_ sender: UIButton) {
        if avatarImageView.image == nil {
            showNotification(type: .error, message: "Please chose your avatar")
            return
        }
        if nameTextField.text!.count <= 6 {
            showNotification(type: .error, message: "User name must have > 6 characters")
            return
        }
        if emailTextField.text?.count == 0 {
            showNotification(type: .error, message: "Please fill your email address")
            return
        }
        if phoneTextField.text?.count == 0 {
            showNotification(type: .error, message: "Please fill your phone number")
            return
        }
        if passWordTextField.text!.count <= 6 {
            showNotification(type: .error, message: "User password must have > 6 characters")
            return
        }
        var userInfo: [String: Any] = [String: Any]()
        userInfo["name"] = nameTextField.text
        userInfo["avatar"] = avatarImageView.image
        userInfo["email"] = emailTextField.text
        userInfo["phone"] = phoneTextField.text
        ApplicationObject.setUserInfo(userInfo: userInfo)
        view.endEditing(true)
        showMainTab()
    }
    // MARK: - Action
    func showMainTab() {
        let timeLineTabbar = ApplicationObject.getStoryBoardByID(storyBoardID: .timeline).instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate!.window!.rootViewController = timeLineTabbar
    }
    func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let pickerView = UIImagePickerController.init()
        pickerView.sourceType = sourceType
        pickerView.allowsEditing = true
        pickerView.delegate = self
        present(pickerView, animated: true, completion: nil)
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
// MARK: - UIimagepickerController Delegate
extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            avatarImageView.image = image
            addPhotoLabel.textColor = UIColor.clear
        }
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
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
}
