//
//  BrandedImageView.swift
//  ImageGalleryApp
//
//  Created by Oleg Kasarin on 30/01/2024.
//

import Foundation
import Kingfisher
import UIKit

final class BrandedImageView: UIImageView {
    func load(
        imageURL: String,
        lowResolutionURL: String? = nil,
        placeholder: UIImage?,
        completion: (() -> Void)? = nil
    ) {
        let url = URL(string: imageURL)
        
        var options: KingfisherOptionsInfo = [
//            .processor(DownsamplingImageProcessor(size: bounds.size)),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.5)),
            .cacheOriginalImage
        ]
        
        if
            let lowResolutionURL = lowResolutionURL,
            let lowURL = URL(string: lowResolutionURL)
        {
            options.append(.lowDataMode(.network(lowURL)))
        }
        
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options,
            progressBlock: nil
        ) { _ in completion?() }
    }
}
