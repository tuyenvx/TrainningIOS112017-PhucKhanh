//
//  SelectAvatarViewController.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/26/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit
protocol SelectAvatarCollectionViewCellDeleage: class {
    func didSelectedAvatar(avatarURL: String)
}
class SelectAvatarViewController: UIViewController {
    @IBOutlet weak private var collectionView: UICollectionView!
    weak var delegate: SelectAvatarCollectionViewCellDeleage?
    private var avatars = [String]()
    private var avatarStore = ChatRoomAvatarStore.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
    }
    // MARK: - Init
    func setDefaults() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "SelectAvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectAvatarCollectionViewCell")
        avatars = avatarStore.getAvatars()
    }
}
// MARK: - CollectionView DataSource
extension SelectAvatarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let avatarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectAvatarCollectionViewCell", for: indexPath) as? SelectAvatarCollectionViewCell
        avatarCell?.fillData(avatarURL: avatars[indexPath.row])
        return avatarCell!
    }
}
// MARK: - CollectionView Delegate
extension SelectAvatarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectedAvatar(avatarURL: avatars[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
