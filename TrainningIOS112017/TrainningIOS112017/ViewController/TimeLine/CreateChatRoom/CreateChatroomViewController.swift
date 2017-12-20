//
//  CreateChatroomViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/22/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

protocol CreateChatroomViewControllerDelegate: class {
    func createChatRoomSuccess(chatroomInfo: [String: Any])
}

class CreateChatroomViewController: BaseViewController {
    @IBOutlet weak private var chatroomNameTextField: UITextField!
    @IBOutlet weak private var descriptionTextField: UITextField!
    @IBOutlet weak private var createChatroomButton: UIButton!
    @IBOutlet weak private var backButton: UIBarButtonItem!
    @IBOutlet weak private var chatroomAvatarImageView: UIImageView!
    @IBOutlet weak private var selectChatroomAvatarButton: UIButton!
    @IBOutlet weak private var stackViewCentrerYConstraint: NSLayoutConstraint!
    private var avatarURL: String = ""
    weak var delegate: CreateChatroomViewControllerDelegate?
    var createChatroomAPI = AppAPI()
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
    func setDefaults() {
        chatroomNameTextField.delegate = self
        descriptionTextField.delegate = self
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyBoard))
        view.addGestureRecognizer(tapGesture)
    }
    // MARK: - UIAction
    @IBAction func back(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        createChatroomAPI.cancelRequest()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func selectChatroomAvatar(_ sender: UIButton) {
        guard let selectAvatarImageView = ApplicationObject.getStoryBoardByID(storyBoardID: .timeline).instantiateViewController(withIdentifier: "SelectAvatarViewController") as? SelectAvatarViewController else {
            return
        }
        selectAvatarImageView.delegate = self
        navigationController?.pushViewController(selectAvatarImageView, animated: true)
    }
    @IBAction func createChatroom(_ sender: UIButton) {
        view.endEditing(true)
        if chatroomNameTextField.text?.count == 0 {
            showNotification(type: .error, message: "Please enter the name of chatroom")
            return
        }
        if descriptionTextField.text?.count == 0 {
            showNotification(type: .error, message: "Please enter the description")
            return
        }
//        if avatarURLTextField.text?.count == 0 {
//            showNotification(type: .error, message: "Please enter the avatar of chatroom link")
//        }
        let param: [String: String] = [
            "name": chatroomNameTextField.text!,
            "description": descriptionTextField.text!,
            "avatarUrl": avatarURL
        ]
        setAllButtonEnable(isEnable: false)
        IndicatorManager.showIndicatorView()
        createChatroomAPI.request(httpMethod: .post, param: param, apiType: .createChatroom) { (requestResult) in
            IndicatorManager.hideIndicatorView()
            self.setAllButtonEnable(isEnable: true)
            switch requestResult {
            case let .success(responseData):
                guard let chatroomInfo = responseData["chatroom"] as? [String: Any] else {
                    self.showNotification(type: .error, message: "Some thing went wrong, please try again")
                    return
                }
                self.delegate?.createChatRoomSuccess(chatroomInfo: chatroomInfo)
                self.dismiss(animated: true, completion: nil)
            case let .unSuccess(responseData):
                guard let notifiMessage = responseData[AppKey.message] as? String else {
                    return
                }
                self.showNotification(type: .error, message: notifiMessage)
                if responseData[AppKey.code] as? String == "UNAUTHORIZED" {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        self.gotoLogin()
                    })
                }
            case let .failure(error):
                print(error as Any)
                self.showNotification(type: .error, message: "Can't create chatroom, please try again")
            }
        }
    }
    func gotoLogin() {
        let loginVC = ApplicationObject.getStoryBoardByID(storyBoardID: .login).instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginVC, animated: true, completion: nil)
    }
    func setAllButtonEnable(isEnable: Bool) {
        DispatchQueue.main.async {
            self.createChatroomButton.isEnabled = isEnable
        }
    }
}
// MARK: - UITextFieldDelegate
extension CreateChatroomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case chatroomNameTextField:
            descriptionTextField.becomeFirstResponder()
        case descriptionTextField:
//            avatarURLTextField.becomeFirstResponder()
//        case avatarURLTextField:
            view.endEditing(true)
        default:
            print("Something goes wrong")
        }
        return true
    }
}
// MARK: - SellectAvatarCollectionCell Delegate
extension CreateChatroomViewController: SelectAvatarCollectionViewCellDeleage {
    func didSelectedAvatar(avatarURL: String) {
        if let image = ImageCache.image(forKey: avatarURL) {
            chatroomAvatarImageView.image = image
        }
        self.avatarURL = avatarURL
    }
}
// MARK: - Keyboard
extension CreateChatroomViewController {
    @objc func hideKeyBoard() {
        view.endEditing(true)
    }
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
            let distance = keyboardHeight + 95 - self.view.frame.size.height/2.0 // 95 = 190/2 (stackView height / 2)
            if distance > 0 {
                UIView.transition(with: view, duration: 2.5, options: .allowAnimatedContent, animations: {
                    self.stackViewCentrerYConstraint.constant = -distance - 10
                }, completion: {_ in
                    //
                })
            }
        }
    }
    @objc func keyBoardWillHide(_ notification: Notification) {
        UIView.transition(with: view, duration: 2.5, options: .allowAnimatedContent, animations: {
            self.stackViewCentrerYConstraint.constant = 0
        }, completion: nil)
    }
}
