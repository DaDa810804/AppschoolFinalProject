//
//  ImageCollectionViewCell.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/29.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
      func setupImageView(){
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 200)
        imageView.backgroundColor = .lightGray
        self.addSubview(imageView)
        }
    override func layoutSubviews() {
        setupImageView()
    }
}
