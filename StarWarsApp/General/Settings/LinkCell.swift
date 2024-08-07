//
//  LinkCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 07/08/2024.
//

import UIKit

class LinkCell: UICollectionViewCell {
    let button = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        
        button.pinLeading(to: contentView, constant: 10)
        button.pinTrailing(to: contentView, constant: 10)
        button.backgroundColor = .gray
        button.tintColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        
    }

    func configure(with title: String, tag: Int, target: Any, action: Selector) {
        button.setTitle(title, for: .normal)
        button.tag = tag
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}

