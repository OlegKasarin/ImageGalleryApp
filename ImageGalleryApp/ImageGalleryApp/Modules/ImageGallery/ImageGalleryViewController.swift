//
//  ImageGalleryViewController.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import UIKit

protocol ImageGalleryViewControllerProtocol: AnyObject {
    var viewController: UIViewController { get }

}

final class ImageGalleryViewController: UIViewController {
    var presenter: ImageGalleryPresenterProtocol?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.didTriggerViewLoad()
    }
}

// MARK: - ImageGalleryViewControllerProtocol

extension ImageGalleryViewController: ImageGalleryViewControllerProtocol {
    var viewController: UIViewController {
        self
    }
}
