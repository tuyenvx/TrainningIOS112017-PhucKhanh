//
//  EditProfileTableViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/28/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class EditProfileTableViewController: BaseTableViewController {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var addressTextField: UITextField!
    @IBOutlet weak private var phoneTextField: UITextField!
    @IBOutlet weak private var birthDayTextField: UITextField!
    var userInfo = [String: Any]()
    private var birthDayDatePicker: UIDatePicker = UIDatePicker.init()
    let dateFormater: DateFormatter = {
       let formater = DateFormatter.init()
        formater.dateFormat = "dd/MM/yyyy"
        return formater
    }()
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    // MARK: - Init
    func setDefaults() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        addressTextField.delegate = self
        phoneTextField.delegate = self
        birthDayTextField.inputView = createDatePickerView()
        fillData(data: userInfo)
    }
    func fillData(data: [String: Any]) {
        avatarImageView.image = data[AppKey.avatar] as? UIImage
        nameTextField.text = data[AppKey.username] as? String
        emailTextField.text = data[AppKey.email] as? String
        phoneTextField.text = data[AppKey.phone] as? String
        birthDayTextField.text = data[AppKey.birthDay] as? String
        addressTextField.text = data[AppKey.address] as? String
    }
    func createDatePickerView() -> UIView {
        let datePickerView = UIView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 230))
        birthDayDatePicker.frame = CGRect(x: 0, y: 50, width: datePickerView.frame.width, height: 180)
        let cancelButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        let doneButton = UIButton.init(frame: CGRect(x: view.frame.width - 100, y: 0, width: 100, height: 50))
        let seperatorLine = UIView.init(frame: CGRect(x: 0, y: 50, width: datePickerView.frame.width, height: 1))
        birthDayDatePicker.maximumDate = Date()
        birthDayDatePicker.minimumDate = dateFormater.date(from: "01/01/1890")
        if let str = userInfo[AppKey.birthDay] as? String {
            let birthDay = dateFormater.date(from: str)
            birthDayDatePicker.date = birthDay!
        }
        birthDayDatePicker.datePickerMode = .date
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.black, for: .normal)
        doneButton.addTarget(self, action: #selector(selectedDate), for: .touchUpInside)
        //
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(hideDatePicker), for: .touchUpInside)
        //
        seperatorLine.backgroundColor = UIColor.lightGray
        datePickerView.addSubview(doneButton)
        datePickerView.addSubview(cancelButton)
        datePickerView.addSubview(seperatorLine)
        datePickerView.addSubview(birthDayDatePicker)
        return datePickerView
    }
    // MARK: - IBAction
    @IBAction func changeAvatar(_ sender: UIButton) {
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
    @IBAction func saveChange(_ sender: UIButton) {
        if emailTextField.text!.count <= 6 {
            // show notifi
            return
        }
        if addressTextField.text?.count == 0 {
            return
        }
        if phoneTextField.text?.count == 0 {
            return
        }
        if birthDayTextField.text?.count == 0 {
            return
        }
        userInfo[AppKey.avatar] = avatarImageView.image
        userInfo[AppKey.username] = nameTextField.text
        userInfo[AppKey.address] = addressTextField.text
        userInfo[AppKey.phone] = phoneTextField.text
        userInfo[AppKey.birthDay] = birthDayTextField.text
        userInfo[AppKey.email] = emailTextField.text
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: userInfo), forKey: AppKey.userinfo)
        UserDefaults.standard.synchronize()
        showNotification(type: .info, message: "Update profile success!")
        navigationController?.popViewController(animated: true)
    }
    @objc func selectedDate() {
        let date = birthDayDatePicker.date
        birthDayTextField.text = dateFormater.string(from: date)
        view.endEditing(true)
    }
    @objc func hideDatePicker() {
        self.view.endEditing(true)
    }
    // MARK: - Action
    func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let pickerView = UIImagePickerController.init()
        pickerView.sourceType = sourceType
        pickerView.allowsEditing = true
        pickerView.delegate = self
        present(pickerView, animated: true, completion: nil)
    }
}
// MARK: - UITextField Delegate
extension EditProfileTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
// MARK: - UIimagepickerController Delegate
extension EditProfileTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        avatarImageView.image = image
        dismiss(animated: true, completion: nil)
    }
}
