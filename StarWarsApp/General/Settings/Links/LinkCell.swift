//
//  LinkCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 07/08/2024.
//

import UIKit

class LinkCell: UICollectionViewCell {
    let containerView = UIView()
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
        contentView.addSubview(containerView)
        contentView.addSubview(titleLabel)
        
        containerView.pin(to: contentView)
        titleLabel.pinLeading(to: containerView, constant: 10)
        titleLabel.pinTrailing(to: containerView, constant: 10)
        
        titleLabel.centerHorizontally(to: containerView)
        titleLabel.centerVertically(to: containerView)
        containerView.backgroundColor = .gray
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
    }
    
    func configure(with name: String) {
        titleLabel.text = "\(name)"
    }
}
