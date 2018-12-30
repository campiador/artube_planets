//
//  CollectionViewCell.swift
//  ViewAnimator_Example
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView.superview == nil {
            imageView.frame = bounds
            imageView.layer.cornerRadius = layer.cornerRadius
            addSubview(imageView)
        }
    }
}
