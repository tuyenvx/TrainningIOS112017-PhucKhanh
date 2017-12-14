//
//  ImageCache.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/19/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class ImageCache {
    static private let cache = NSCache<NSString, UIImage>()
    class func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString )
    }
    class func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    class func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    class func deleteAllImage() {
        cache.removeAllObjects()
    }
}
