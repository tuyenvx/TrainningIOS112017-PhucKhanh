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
    func fillData(data: [String: Any]) {
//        avatarImageView.image = data["image"] as? UIImage
        avatarImageView.image = data["avatar"] as? UIImage ?? UIImage.init()
        userNameLabel.text = data["name"] as? String
        timeLabel.text = data["time"] as? String
        statusLabel.text = data["status"] as? String
        if data["image"] != nil {
            statusImageViewHeightConstraint.constant = 220
            statusImageView.image = data["image"] as? UIImage
        } else {
            statusImageViewHeightConstraint.constant = 0
        }
        numberOfLikesLabel.text = "\(data["numberOfLike"] ?? 0) Likes"
        numberOfCommentsLabel.text = "\(data["numberOfComment"] ?? 0) Comments"
    }
    func setStatus(status: String) {
        statusLabel.text = status
    }
    // MARK: - UIAction
    @IBAction func like(_ sender: UIButton) {
        setLikeButtonHighLighted(isHighlight: !likeLabel.isHighlighted)
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
    func setLikeButtonHighLighted(isHighlight: Bool) {
        likeLabel.isHighlighted = isHighlight
        isHighlight == true ? (likeImageView.image = #imageLiteral(resourceName: "ic_like_highlight")) : (likeImageView.image = #imageLiteral(resourceName: "ic_like"))
        var numberOfLikeString = numberOfLikesLabel.text
        numberOfLikeString = numberOfLikeString?.replacingOccurrences(of: " Likes", with: "")
        var numberOfLike: Int = Int(numberOfLikeString!) ?? 0
        isHighlight == true ? (numberOfLike+=1) : (numberOfLike-=1)
        numberOfLikesLabel.text = "\(numberOfLike) Likes"
    }
//    override func prepareForReuse() {
//        setLikeButtonHighLighted(isHighlight: false)
//    }
}
