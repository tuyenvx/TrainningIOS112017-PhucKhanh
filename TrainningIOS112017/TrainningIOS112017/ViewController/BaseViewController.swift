//
//  BaseViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/29/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var notifiView = UIView.init(frame: CGRect(x: 0, y: -64, width: UIScreen.main.bounds.size.width, height: 64))
    var messageLabel = UILabel.init(frame: CGRect(x: 15, y: 5, width: UIScreen.main.bounds.size.width - 30, height: 54))
    let alertWindow = UIWindow.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
    override func viewDidLoad() {
        notifiView.backgroundColor = UIColor.clear
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        notifiView.addSubview(messageLabel)
        alertWindow.windowLevel = UIWindowLevelAlert
        alertWindow.addSubview(notifiView)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        alertWindow.isHidden = true
    }
    @objc func hideNotifi() {
        UIView.transition(with: view, duration: 0.3, options: .curveEaseOut, animations: {
            DispatchQueue.main.async {
                self.notifiView.frame = CGRect(x: 0, y: -64, width: UIScreen.main.bounds.size.width, height: 64)
                self.alertWindow.isHidden = true
            }
        }, completion: nil)
    }
}
extension BaseViewController {
    func showNotification(type: NotificationType, message: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: hideNotifi())
        DispatchQueue.main.async {
            self.notifiView.isHidden = false
            switch type {
            case .error:
                self.notifiView.backgroundColor = UIColor.red
            default:
                self.notifiView.backgroundColor = UIColor.blue
            }
            self.messageLabel.text = message
            UIView.transition(with: self.view, duration: 0.3, options: .curveEaseIn, animations: {
                self.notifiView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
                self.alertWindow.makeKeyAndVisible()
            }, completion: { _ in
                self.perform(#selector(self.hideNotifi), with: nil, afterDelay: 3.0)
            })
        }
    }
}
