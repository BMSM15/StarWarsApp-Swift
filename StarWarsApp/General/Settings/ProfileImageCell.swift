//
//  ProfileImageCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 07/08/2024.
//

import UIKit

class ProfileImageCell: UICollectionViewCell {
    let profileImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)
        
        profileImageView.pinSafeAreaTop(to: contentView, constant: 10)
        profileImageView.centerHorizontally(to: contentView)
        profileImageView.widthEqual(to: contentView, multiplier: 0.3)
        profileImageView.heightEqual(to: contentView, multiplier: 1)
    }
    
    func configure(with imageUrl: URL) {
        profileImageView.load(url: imageUrl)
    }
}

