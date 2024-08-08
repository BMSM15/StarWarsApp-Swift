//
//  LinkCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 07/08/2024.
//

import UIKit

class LinkCell: UICollectionViewCell {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        titleLabel.pinTop(to: contentView, constant: 10)
        titleLabel.pinLeading(to: contentView, constant: 10)
        titleLabel.centerHorizontally(to: contentView)
        titleLabel.backgroundColor = .gray
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
    }
    
    func configure(with name: String) {
        titleLabel.text = "\(name)"
    }
}
