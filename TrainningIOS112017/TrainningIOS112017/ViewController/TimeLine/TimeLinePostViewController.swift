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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        setDefaults()
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
    // MARK: - UITextfield delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }
}
