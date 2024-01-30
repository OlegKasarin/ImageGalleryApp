//
//  ImageGalleryCollectionViewCell.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import UIKit

struct ImageGalleryCellItem {
    let title: String
    let description: String
    let imageURL: String
    let isFavorite: Bool
}

final class ImageGalleryCollectionViewCell: UICollectionViewCell {
    static var cellID = "ImageGalleryCollectionViewCell"
    
    lazy var imageView: BrandedImageView = {
        let view = BrandedImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let favoriteImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "heart")?.withTintColor(.red)
        view.kf.indicatorType = .activity
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
    }
    
    func refresh(item: ImageGalleryCellItem) {
        imageView.load(imageURL: item.imageURL, placeholder: nil)
        favoriteImageView.isHidden = !item.isFavorite
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
        
        addSubview(favoriteImageView)
    }
}
