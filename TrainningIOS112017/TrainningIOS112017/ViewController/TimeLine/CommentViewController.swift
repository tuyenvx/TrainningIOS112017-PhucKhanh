//
//  CommentViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/23/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak private var commitTextField: UITextField!
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var tableView: UITableView!
    var index = 0
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefauts()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        addKeyBoardNotifi()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        removeKeyBoardNotifi()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - init
    func setDefauts() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib (nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        tableView.register(UINib.init(nibName: "StatusInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "StatusInfoTableViewCell")
        tableView.estimatedRowHeight = 40
        commitTextField.delegate = self
    }
    // MARK: - UITableViewDelegate + datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 15
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let statusInfoCell = tableView.dequeueReusableCell(withIdentifier: "StatusInfoTableViewCell")
            return statusInfoCell!
        } else {
            let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell")
            return commentCell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    // MARK: - UIAction
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
            UIView.transition(with: view, duration: 2.5, options: .allowAnimatedContent, animations: {
                self.bottomConstraint.constant = -keyboardHeight
            }, completion: {_ in
                //
            })
        }
    }
    @objc func keyBoardWillHide(_ notification: Notification) {
        UIView.transition(with: view, duration: 2.5, options: .allowAnimatedContent, animations: {
            self.bottomConstraint.constant = 0
        }, completion: nil)
    }
    // MARK: - UItextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
