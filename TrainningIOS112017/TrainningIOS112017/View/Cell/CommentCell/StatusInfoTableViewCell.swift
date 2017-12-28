//
//  StatusInfoTableViewCell.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/23/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class StatusInfoTableViewCell: UITableViewCell {
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var statusImageView: UIImageView!
    @IBOutlet weak private var likeLabel: UILabel!
    @IBOutlet weak private var likeImageView: UIImageView!
    @IBOutlet weak private var commentLabel: UILabel!
    @IBOutlet weak private var commentImageView: UIImageView!
    @IBOutlet weak private var imageViewHeightConstraint: NSLayoutConstraint!
    var item = PostItem()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    // MARK: - IBAction
    @IBAction func like(_ sender: UIButton) {
        item.isLiked = !item.isLiked
        setLikeButtonHighLighted()
    }
    @IBAction func comment(_ sender: UIButton) {
    }
    func fillData() {
        statusLabel.text = item.status
        if item.image == nil {
            imageViewHeightConstraint.constant = 0
        } else {
            imageViewHeightConstraint.constant = 220
            statusImageView?.image = item.image
        }
        setLikeButtonHighLighted()
    }
    func setLikeButtonHighLighted() {
        likeLabel.isHighlighted = item.isLiked
        item.isLiked == true ? (likeImageView.image = #imageLiteral(resourceName: "ic_like_highlight")) : (likeImageView.image = #imageLiteral(resourceName: "ic_like"))
    }
}
