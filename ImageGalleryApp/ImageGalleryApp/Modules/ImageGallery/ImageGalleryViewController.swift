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
    func append(items: [ImageGalleryCellItem])
    
    func showCenterActivityIndicator()
    func hideCenterActivityIndicator()
    
    func showBottomActivityIndicator()
    func hideBottomActivityIndicator()
}

final class ImageGalleryViewController: UIViewController {
    private let minimumLineSpacing: CGFloat = 10
    private let cellHeight: CGFloat = 200
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
    
    private var centerActivityIndicatorView: UIActivityIndicatorView?
    private var bottomActivityIndicatorView: UIActivityIndicatorView?
    
    private var items: [ImageGalleryCellItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.didTriggerViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.didTriggerViewWillAppear()
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
    
    func append(items: [ImageGalleryCellItem]) {
        self.items.append(contentsOf: items)
        collectionView.reloadData()
    }
    
    func showCenterActivityIndicator() {
        centerActivityIndicatorView?.startAnimating()
    }
    
    func hideCenterActivityIndicator() {
        centerActivityIndicatorView?.stopAnimating()
    }
    
    func showBottomActivityIndicator() {
        bottomActivityIndicatorView?.startAnimating()
    }
    
    func hideBottomActivityIndicator() {
        bottomActivityIndicatorView?.stopAnimating()
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
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.row == items.count - 1 {
            presenter?.didTriggerReachEndOfList()
        }
    }
    
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presenter?.didTriggerSelectItem(index: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.contentSize.width / 2 - sectionInsets.left - sectionInsets.right,
            height: cellHeight
        )
    }
}

// MARK: - Private

private extension ImageGalleryViewController {
    func setup() {
        title = "List Photos"
        setupCollectionView()
        setupCollectionLayout()
        addActivityIndicators()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func addActivityIndicators() {
        let centerIndicatorView = UIActivityIndicatorView(style: .medium)
        centerIndicatorView.hidesWhenStopped = true
        view.addSubview(centerIndicatorView)
        centerIndicatorView.center = view.center
        self.centerActivityIndicatorView = centerIndicatorView
        
        let bottomIndicatorView = UIActivityIndicatorView(style: .medium)
        bottomIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        bottomIndicatorView.hidesWhenStopped = true
        view.addSubview(bottomIndicatorView)
        bottomIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomIndicatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.bottomActivityIndicatorView = bottomIndicatorView
    }
}

// MARK: - Private

private extension ImageGalleryViewController {
    func setupCollectionLayout() {
        collectionView.collectionViewLayout = CollectionViewLayoutBuilder.build(collectionLayout)
    }
    
    // MARK: - Layout
    
    var isLandscape: Bool {
        let isLandscape = traitCollection.verticalSizeClass == .compact
        debugPrint("isLandscape:", isLandscape)
        return isLandscape
    }
    
    var collectionLayout: CollectionLayout {
        isLandscape
            ? padCollectionLayout
            : phoneCollectionLayout
    }
    
    var padCollectionLayout: CollectionLayout {
        let countVisibleCells: CGFloat = 4.5
        let minimumLineSpacing: CGFloat = 32
        let padCellRatio: CGFloat = 3/4
        let sectionInsets = UIEdgeInsets(top: 20, left: 32, bottom: 20, right: 32)
        
        return CollectionLayout(
            cellRatio: padCellRatio,
            visibleCountInRow: countVisibleCells,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
            scrollDirection: .vertical
        )
    }
    
    var phoneCollectionLayout: CollectionLayout {
        let countVisibleCells: CGFloat = 2
        let minimumLineSpacing: CGFloat = 16
        let phoneCellRation: CGFloat = 1
        let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        return CollectionLayout(
            cellRatio: phoneCellRation,
            visibleCountInRow: countVisibleCells,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
            scrollDirection: .vertical
        )
    }
}
