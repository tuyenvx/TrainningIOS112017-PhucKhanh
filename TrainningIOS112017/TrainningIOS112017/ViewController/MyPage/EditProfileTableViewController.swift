//
//  EditProfileTableViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/28/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class EditProfileTableViewController: BaseTableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var addressTextField: UITextField!
    @IBOutlet weak private var phoneTextField: UITextField!
    @IBOutlet weak private var birthDayDatePicker: UIDatePicker!
    let dateFormater: DateFormatter = {
       let formater = DateFormatter.init()
        formater.dateFormat = "dd/MM/yyyy"
        return formater
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
        birthDayDatePicker.maximumDate = Date()
        birthDayDatePicker.minimumDate = dateFormater.date(from: "01/01/1890")
        birthDayDatePicker.setDate(dateFormater.date(from: "25/12/1994")!, animated: true)
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
        showNotification(type: .info, message: "Update profile success!")
    }
    // MARK: - Action
    func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let pickerView = UIImagePickerController.init()
        pickerView.sourceType = sourceType
        pickerView.allowsEditing = true
        pickerView.delegate = self
        present(pickerView, animated: true, completion: nil)
    }
    // MARK: - UIimagepickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        avatarImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
