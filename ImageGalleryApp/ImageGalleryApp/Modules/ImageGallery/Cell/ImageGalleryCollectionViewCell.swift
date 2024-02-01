//
//  ImageGalleryCollectionViewCell.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import UIKit

final class ImageGalleryCollectionViewCell: UICollectionViewCell {
    static var cellID = "ImageGalleryCollectionViewCell"
    private let favoriteImageSize: CGFloat = 24
    
    private lazy var imageView: BrandedImageView = {
        let view = BrandedImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.kf.indicatorType = .activity
        return view
    }()
    
    private let favoriteImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        favoriteImageView.isHidden = true
    }
    
    func refresh(item: ImageGalleryCellItem) {
        imageView.load(imageURL: item.imageThumbURL, placeholder: nil)
        favoriteImageView.isHidden = !item.isFavorite
    }
    
    func cancelDownloadTask() {
        imageView.kf.cancelDownloadTask()
    }
}

// MARK: - Private

private extension ImageGalleryCollectionViewCell {
    func setup() {
        self.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(favoriteImageView)
        favoriteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        favoriteImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        favoriteImageView.heightAnchor.constraint(equalToConstant: favoriteImageSize).isActive = true
        favoriteImageView.widthAnchor.constraint(equalToConstant: favoriteImageSize).isActive = true
    }
}
