//
//  ImageDetailsCollectionViewCell.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import UIKit

final class ImageDetailsCollectionViewCell: UICollectionViewCell {
    static var cellID = "ImageDetailsCollectionViewCell"
    static let nibName = "ImageDetailsCollectionViewCell"
    
    @IBOutlet private weak var imageView: BrandedImageView?
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    private var favoriteImage: UIImage? {
        UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    }
    
    private var unfavoriteImage: UIImage? {
        UIImage(systemName: "heart")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    }
    
    private var id: String?
    private var action: ((String, Bool) -> Void)?
    private var isFavorite: Bool = false {
        didSet {
            favoriteImageView.image = isFavorite ? favoriteImage : unfavoriteImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        descriptionLabel.text = nil
        favoriteImageView.image = nil
    }
    
    func refresh(item: ImageGalleryCellItem, action: @escaping (String, Bool) -> Void) {
        id = item.id
        self.action = action
        
        imageView?.load(
            imageURL: item.imageRegularURL ?? item.imageThumbURL,
            lowResolutionURL: item.imageThumbURL,
            placeholder: nil
        )
        descriptionLabel.text = item.description
        
        isFavorite = item.isFavorite
    }
    
    @IBAction private func favoriteAction(_ sender: UIButton) {
        isFavorite.toggle()
        animateTap()
        
        guard let id = id, let action = action else {
            return
        }
        
        action(id, isFavorite)
    }
    
    private func animateTap() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.favoriteImageView.transform = .init(scaleX: 1.5, y: 1.5)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: [],
                    animations: {
                        self.favoriteImageView.transform = .identity
                    },
                    completion: { _ in }
                )
            }
        )
    }
}
