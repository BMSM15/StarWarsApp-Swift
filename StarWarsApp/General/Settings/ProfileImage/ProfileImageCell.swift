//
//  ProfileImageCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 07/08/2024.
//

import UIKit

class ProfileImageCell: UICollectionViewCell {
    let profileImageView = ImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.cancel()
    }
    
    private func setupViews() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)
        
        profileImageView.centerVertically(to: contentView)
        profileImageView.centerHorizontally(to: contentView)
        profileImageView.widthEqual(to: contentView, multiplier: 0.3)
        profileImageView.heightEqual(to: contentView, multiplier: 1)
    }
    
    func configure(with imageUrl: URL) {
        profileImageView.setImage(url: imageUrl)
    }
}


