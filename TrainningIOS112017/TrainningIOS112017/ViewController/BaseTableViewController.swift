//
//  BaseTableViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/29/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    var notifiView = UIView.init(frame: CGRect(x: 0, y: -64, width: UIScreen.main.bounds.size.width, height: 64))
    var messageLabel = UILabel.init(frame: CGRect(x: 15, y: 5, width: UIScreen.main.bounds.size.width - 30, height: 54))
    override func viewDidLoad() {
        notifiView.backgroundColor = UIColor.clear
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        notifiView.addSubview(messageLabel)
        if navigationController != nil {
            self.navigationController?.view.addSubview(notifiView)
        } else {
            view.insertSubview(notifiView, at: 999)
        }
        notifiView.layer.zPosition = 999
    }
    @objc func hideNotifi() {
        UIView.transition(with: view, duration: 0.3, options: .curveEaseOut, animations: {
            self.notifiView.frame = CGRect(x: 0, y: -64, width: UIScreen.main.bounds.size.width, height: 64)
        }, completion: nil)
    }
}
extension BaseTableViewController {
    func showNotification(type: NotificationType, message: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: hideNotifi())
        switch type {
        case .error:
            notifiView.backgroundColor = UIColor.red
        default:
            notifiView.backgroundColor = UIColor.blue
        }
        messageLabel.text = message
        UIView.transition(with: view, duration: 0.3, options: .curveEaseIn, animations: {
            self.notifiView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
        }, completion: { _ in
            self.perform(#selector(self.hideNotifi), with: nil, afterDelay: 3.0)
        })
    }
}
