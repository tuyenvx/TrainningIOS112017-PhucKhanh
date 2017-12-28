//
//  IndicatorManager.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/11/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import Foundation
import UIKit

class IndicatorManager {
    static let indicatorView = { () -> UIView in
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        view.layer.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5).cgColor
        view.layer.cornerRadius = 5.0
        return view
    } ()
    static let activitiIndicator = { () -> UIActivityIndicatorView in
        let indicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = .whiteLarge
        return indicator
    }()
    class func showIndicatorView() {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        DispatchQueue.main.async {
            window?.addSubview(indicatorView)
            indicatorView.center = window!.center
            indicatorView.addSubview(activitiIndicator)
            activitiIndicator.startAnimating()
        }
    }
    class func hideIndicatorView() {
        DispatchQueue.main.async {
            activitiIndicator.stopAnimating()
            indicatorView.removeFromSuperview()
        }
    }
}
