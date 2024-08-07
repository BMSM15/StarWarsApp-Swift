//
//  NameAgeCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 07/08/2024.
//

import UIKit

class NameAgeCell: UICollectionViewCell {
    let nameLabel = UILabel()
    let ageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        contentView.addSubview(ageLabel)
        
        nameLabel.pinTopToBottom(to: contentView, constant: 10)
        nameLabel.pinLeading(to: contentView, constant: 10)
        ageLabel.pinTopToBottom(to: nameLabel, constant: 10)
        ageLabel.pinLeading(to: contentView, constant: 10)
        
    }
    
    func configure(name: String, age: Int) {
        nameLabel.text = "Name: \(name)"
        ageLabel.text = "Age: \(age)"
    }
}

