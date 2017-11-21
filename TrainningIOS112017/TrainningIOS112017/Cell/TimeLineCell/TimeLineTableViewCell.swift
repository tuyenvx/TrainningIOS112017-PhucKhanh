//
//  TimeLineTableViewCell.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/21/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

protocol TimeLineTableViewCellDelegate: class {
    func comment(index: Int)
}
class TimeLineTableViewCell: UITableViewCell {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var statusImageView: UIImageView!
    @IBOutlet weak private var numberOfCommentsLabel: UILabel!
    @IBOutlet weak private var numberOfLikesLabel: UILabel!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var seperatorLineHeightConstraint: NSLayoutConstraint!
    weak var delegate: TimeLineTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //
    func fillData(data: NSDictionary) {
        //
    }
    func setStatus(status: String) {
        statusLabel.text = status
    }
    // MARK: - UIAction
    @IBAction func like(_ sender: UIButton) {
    }
    @IBAction func comment(_ sender: UIButton) {
        guard let tableView = self.superview as? UITableView else {
            return
        }
        let index = tableView.indexPath(for: self)
        delegate?.comment(index: index!.row)
    }
    @IBAction func share(_ sender: UIButton) {
        //
    }
    func hideSeperatorLine() {
        seperatorLineHeightConstraint.constant = 0
    }
}
