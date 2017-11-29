//
//  CommentTableViewCell.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/22/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func fillData(data: [String: Any]) {
        avatarImageView.image = data[""] as? UIImage
        userNameLabel.text = data[""] as? String
        commentLabel.text = data[""] as? String
    }
}
