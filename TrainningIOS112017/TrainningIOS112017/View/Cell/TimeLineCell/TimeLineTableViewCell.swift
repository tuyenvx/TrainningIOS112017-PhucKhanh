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
    @IBOutlet weak private var likeLabel: UILabel!
    @IBOutlet weak private var likeImageView: UIImageView!
    @IBOutlet weak private var statusImageViewHeightConstraint: NSLayoutConstraint!
    var item = PostItem()
    weak var delegate: TimeLineTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //
    func fillData() {
        avatarImageView.image = item.avatar
        userNameLabel.text = item.name
        timeLabel.text = item.time
        statusLabel.text = item.status
        if item.image != nil {
            statusImageViewHeightConstraint.constant = 220
            statusImageView.image = item.image
        } else {
            statusImageViewHeightConstraint.constant = 0
        }
        numberOfLikesLabel.text = "\(item.numberOfLike ?? 0) Likes"
        numberOfCommentsLabel.text = "\(item.numberOfComment ?? 0) Comments"
        setLikeButtonHighLighted()
    }
    func setStatus(status: String) {
        statusLabel.text = status
    }
    // MARK: - UIAction
    @IBAction func like(_ sender: UIButton) {
        item.isLiked = !item.isLiked
        if item.isLiked == true {
            item.numberOfLike = item.numberOfLike! + 1
        } else {
            item.numberOfLike = item.numberOfLike! - 1
        }
        setLikeButtonHighLighted()
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
    func setLikeButtonHighLighted() {
        likeLabel.isHighlighted = item.isLiked
        item.isLiked == true ? (likeImageView.image = #imageLiteral(resourceName: "ic_like_highlight")) : (likeImageView.image = #imageLiteral(resourceName: "ic_like"))
        numberOfLikesLabel.text = "\(item.numberOfLike ?? 0) Likes"
    }
}
