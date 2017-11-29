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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLikeButtonHighLighted(isHighlight: true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    // MARK: - IBAction
    @IBAction func like(_ sender: UIButton) {
        setLikeButtonHighLighted(isHighlight: !likeLabel.isHighlighted)
    }
    @IBAction func comment(_ sender: UIButton) {
    }
    func fillData(data: [String: Any]) {
        statusLabel.text = data[""] as? String
        statusImageView.image = data[""] as? UIImage
    }
    func setLikeButtonHighLighted(isHighlight: Bool) {
        likeLabel.isHighlighted = isHighlight
        isHighlight == true ? (likeImageView.image = #imageLiteral(resourceName: "ic_like_highlight")) : (likeImageView.image = #imageLiteral(resourceName: "ic_like"))
    }
}
