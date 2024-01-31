//
//  ImageDetailsViewController.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import UIKit

protocol ImageDetailsViewControllerProtocol {
    func setup(items: [])
}

final class ImageDetailsViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
//            collectionView.delegate = self
            collectionView.isPagingEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

// MARK: - UICollectionViewDataSource

extension ImageDetailsViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageGalleryCollectionViewCell.cellID,
            for: indexPath
        )

        if let cardCell = cell as? ImageGalleryCollectionViewCell {
            cardCell.refresh(item: items[indexPath.row])
        }

        return cell
    }
}
