//
//  TimeLinePostViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/22/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class TimeLinePostViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var userNamaLabel: UILabel!
    @IBOutlet weak private var statusTextView: UITextView!
    @IBOutlet weak private var scrollViewBottomConstraint: NSLayoutConstraint!
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - init
    func setDefaults() {
        statusTextView.delegate = self
    }
    // MARK: - UIAction
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func postStatus(_ sender: UIButton) {
        //
    }
    @IBAction func hideKeyBoard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    // MARK: - UITextfield delegate
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
}
