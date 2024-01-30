//
//  ImageGalleryViewController.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import UIKit

protocol ImageGalleryViewControllerProtocol: AnyObject {
    var viewController: UIViewController { get }
    func refresh(items: [ImageGalleryCellItem])
}

final class ImageGalleryViewController: UIViewController {
    private let minimumLineSpacing: CGFloat = 10
    private let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    var presenter: ImageGalleryPresenterProtocol?
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.sectionInset = sectionInsets
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            ImageGalleryCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageGalleryCollectionViewCell.cellID
        )
        
        return collectionView
    }()
    
    private var items: [ImageGalleryCellItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Photos"
        setup()
        presenter?.didTriggerViewLoad()
    }
}

// MARK: - ImageGalleryViewControllerProtocol

extension ImageGalleryViewController: ImageGalleryViewControllerProtocol {
    var viewController: UIViewController {
        self
    }
    
    func refresh(items: [ImageGalleryCellItem]) {
        self.items = items
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ImageGalleryViewController: UICollectionViewDataSource {
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

// MARK: - UICollectionViewDelegate

extension ImageGalleryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        // This will cancel all unfinished downloading task when the cell disappearing.
        guard let imageCell = cell as? ImageGalleryCollectionViewCell else {
            return
        }
        
        imageCell.imageView.kf.cancelDownloadTask()
    }
}

// MARK: - Private

private extension ImageGalleryViewController {
    func setup() {
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
