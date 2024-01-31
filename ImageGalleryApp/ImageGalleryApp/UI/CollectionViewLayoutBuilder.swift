//
//  CollectionViewLayoutBuilder.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 31/01/2024.
//

import Foundation
import UIKit

struct CollectionLayout {
    let cellRatio: CGFloat
    let visibleCountInRow: CGFloat
    let minimumLineSpacing: CGFloat
    let sectionInset: UIEdgeInsets
    let scrollDirection: UICollectionView.ScrollDirection?
    let minimumInteritemSpacing: CGFloat?
    
    var cellWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let paddings = sectionInset.left + sectionInset.right
        let spacing = CGFloat(visibleCountInRow - 1) * minimumLineSpacing
        
        let cellWidth = (screenWidth - paddings - spacing) / visibleCountInRow
        return cellWidth
    }
    
    var cellHeight: CGFloat {
        cellWidth / cellRatio
    }
    
    var cellSize: CGSize {
        CGSize(width: cellWidth, height: cellHeight)
    }
    
    init(
        cellRatio: CGFloat,
        visibleCountInRow: CGFloat,
        minimumLineSpacing: CGFloat,
        sectionInset: UIEdgeInsets,
        scrollDirection: UICollectionView.ScrollDirection? = nil,
        minimumInteritemSpacing: CGFloat? = nil
    ) {
        self.cellRatio = cellRatio
        self.visibleCountInRow = visibleCountInRow
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        self.scrollDirection = scrollDirection
        self.minimumInteritemSpacing = minimumInteritemSpacing
    }
}

struct CollectionViewLayoutBuilder {
    static func build(_ layout: CollectionLayout) -> UICollectionViewFlowLayout {
        let size = CGSize(
            width: layout.cellWidth.rounded(.down),
            height: layout.cellHeight.rounded(.down)
        )
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = layout.sectionInset
        collectionViewLayout.itemSize = size
        collectionViewLayout.minimumLineSpacing = layout.minimumLineSpacing
        
        if let scrollDirection = layout.scrollDirection {
            collectionViewLayout.scrollDirection = scrollDirection
        }
        
        if let minimumInteritemSpacing = layout.minimumInteritemSpacing {
            collectionViewLayout.minimumInteritemSpacing = minimumInteritemSpacing
        }
        
        return collectionViewLayout
    }
}
