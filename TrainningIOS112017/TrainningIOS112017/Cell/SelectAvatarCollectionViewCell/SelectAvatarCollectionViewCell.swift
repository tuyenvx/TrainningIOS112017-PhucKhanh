//
//  SelectAvatarCollectionViewCell.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/26/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class SelectAvatarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillData(avatarURL: String) {
        if let image = ImageCache.image(forKey: avatarURL) {
            avatarImageView.image = image
        } else {
            var dowloadImageAPI = AppAPI()
            let param = [
                AppKey.avatarUrl: avatarURL
            ]
            dowloadImageAPI.getImage(httpMethod: .get, param: param, apiType: .dowloadImage, completionHandle: { (data, error) in
                if let imageData = data as? Data {
                    DispatchQueue.main.async {
                        let image = ApplicationObject.resizeImage(image: UIImage.init(data: imageData), targetSize: CGSize.init(width: 150, height: 150))
                        ImageCache.setImage(image!, forKey: avatarURL)
                        self.avatarImageView.image = image
                    }
                } else {
                    print(error as Any)
                }
            })
        }
    }
}
