//
//  ChatRoomTableViewCell.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/14/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var chatRoomNameLabel: UILabel!
    @IBOutlet weak private var chatRoomDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillData(data: [String: Any]) {
        chatRoomNameLabel.text = data[AppKey.name] as? String
        chatRoomDescriptionLabel.text = data[AppKey.description] as? String
        guard let avatarUrl = data[AppKey.avatarUrl] as? String else {
           return
        }
        if let image = ImageCache.image(forKey: avatarUrl) {
            avatarImageView.image = image
        } else {
            var dowloadImageAPI = AppAPI()
            dowloadImageAPI.getImage(httpMethod: .get, param: data, apiType: .dowloadImage, completionHandle: { (data, error) in
                if let imageData = data {
                    DispatchQueue.main.async {
                        let image = ApplicationObject.resizeImage(image: UIImage.init(data: (imageData as? Data)!), targetSize: CGSize.init(width: 105, height: 105))
                        ImageCache.setImage(image!, forKey: avatarUrl)
                        self.avatarImageView.image = image
                    }
                } else {
                    print(error as Any)
                }
            })
        }
    }
    override func prepareForReuse() {
        avatarImageView.image = #imageLiteral(resourceName: "ava_post")
        chatRoomNameLabel.text = ""
        chatRoomDescriptionLabel.text = ""
    }
}
