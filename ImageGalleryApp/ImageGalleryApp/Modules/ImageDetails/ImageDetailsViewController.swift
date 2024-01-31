//
//  ImageDetailsViewController.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import UIKit

protocol ImageDetailsViewControllerProtocol: AnyObject {
    func setup(items: [ImageGalleryCellItem])
    func setup(selectedIndex: Int)
    func refresh()
}

final class ImageDetailsViewController: UIViewController {
    var presenter: ImageDetailsPresenterProtocol?
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.isPagingEnabled = true
            
            let nib = UINib(nibName: ImageDetailsCollectionViewCell.nibName, bundle: nil)
            let id = ImageDetailsCollectionViewCell.cellID
            collectionView.register(nib, forCellWithReuseIdentifier: id)
        }
    }
    
    private var items: [ImageGalleryCellItem] = []
    private var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Details"
        presenter?.didTriggerViewLoad()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        presenter?.didTriggerViewIsAppearing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let selectedIndex = selectedIndex, collectionView.frame.width != .zero else {
            return
        }
        
        let offset = selectedIndex * Int(collectionView.frame.width)
        collectionView.setContentOffset(
            CGPoint(x: offset, y: .zero),
            animated: false
        )
        
        self.selectedIndex = nil
    }
}

// MARK: - ImageDetailsViewControllerProtocol

extension ImageDetailsViewController: ImageDetailsViewControllerProtocol {
    func setup(items: [ImageGalleryCellItem]) {
        self.items = items
    }
    
    func setup(selectedIndex: Int) {
        self.selectedIndex = selectedIndex
    }
    
    func refresh() {
        collectionView.reloadData()
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
            withReuseIdentifier: ImageDetailsCollectionViewCell.cellID,
            for: indexPath
        )

        if let viewCell = cell as? ImageDetailsCollectionViewCell {
            viewCell.refresh(item: items[indexPath.row]) { [weak self] id, isFavorite in
                self?.presenter?.didTriggerFavorite(id: id, isFavorite: isFavorite)
            }
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        collectionView.frame.size
    }
}
