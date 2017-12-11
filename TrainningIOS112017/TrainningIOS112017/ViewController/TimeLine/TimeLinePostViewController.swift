//
//  TimeLinePostViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/22/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class TimeLinePostViewController: BaseViewController {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var userNamaLabel: UILabel!
    @IBOutlet weak private var statusTextView: UITextView!
    @IBOutlet weak private var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var statusImageView: UIImageView!
    @IBOutlet weak private var bottomViewBottomConstraint: NSLayoutConstraint! // bottom view top = safe area top + constraint
    @IBOutlet weak private var bottomView: UIView!
    @IBOutlet weak private var imageHeightConstraint: NSLayoutConstraint!
    private var hasStatus = false
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        setDefaults()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addKeyBoardNotifi()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyBoardNotifi()
    }
    // MARK: - init
    func setDefaults() {
        statusTextView.delegate = self
        if let userInfo = ApplicationObject.getUserInfo() {
            avatarImageView.image = userInfo["avatar"] as? UIImage
            userNamaLabel.text = userInfo["name"] as? String
        }
    }
    // MARK: - UIAction
    @IBAction func cancel(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func postStatus(_ sender: UIButton) {
        view.endEditing(true)
        if !hasStatus {
            showNotification(type: .error, message: "Enter your status please !")
            return
        }
        let postItem = PostItem.init(avatar: avatarImageView.image!, name: userNamaLabel.text!, time: "a minutes", status: statusTextView.text, image: statusImageView.image, numberOfLike: 0, numberOfComment: 0)
        NotificationCenter.default.post(name: .postStatus, object: nil, userInfo: ["postItem": postItem])
        dismiss(animated: true, completion: nil)
    }
    @IBAction func hideKeyBoard(_ sender: UITapGestureRecognizer) {
        if statusTextView.isFirstResponder {
            view.endEditing(true)
        } else {
            statusTextView.becomeFirstResponder()
        }
    }
    @IBAction func swipeGestureUp(_ sender: Any) {
        UIView.transition(with: view, duration: 0.3, options: .curveEaseIn, animations: {
            self.bottomViewBottomConstraint.constant = 10
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.bottomView.alpha = 0
        })
    }
     func swipeGestureDown(_ sender: Any) {
        UIView.transition(with: view, duration: 0.3, options: .curveEaseOut, animations: {
            self.bottomViewBottomConstraint.constant = 306
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.bottomView.alpha = 1
        })
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
            let distance = keyboardHeight - 65
            if distance > 0 {
                UIView.transition(with: view, duration: 2.5, options: .allowAnimatedContent, animations: {
                    self.scrollViewBottomConstraint.constant = distance
                }, completion: {_ in
                    //
                })
            }
        }
    }
    @objc func keyBoardWillHide(_ notification: Notification) {
        UIView.transition(with: view, duration: 2.5, options: .allowAnimatedContent, animations: {
            self.scrollViewBottomConstraint.constant = 0
        }, completion: nil)
    }
    // MARK: -
    func changeAvatar() {
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
    func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let pickerView = UIImagePickerController.init()
        pickerView.sourceType = sourceType
        pickerView.allowsEditing = true
        pickerView.delegate = self
        present(pickerView, animated: true, completion: nil)
    }
}
// MARK: -
extension Notification.Name {
    static let postStatus = Notification.Name("PostStatusSuccess")
}
// MARK: - UIimagepickerController Delegate
extension TimeLinePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        statusImageView.image = image
        imageHeightConstraint.constant = 280
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - UITextfield delegate
extension TimeLinePostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor != UIColor.black {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = "what's on your minds?"
            textView.textColor = UIColor.lightGray
            hasStatus = false
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            hasStatus = true
        } else {
            hasStatus = false
        }
    }
}
