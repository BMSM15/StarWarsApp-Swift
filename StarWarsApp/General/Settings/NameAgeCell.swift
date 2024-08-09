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
        
        nameLabel.pinTop(to: contentView, constant: 10)
        nameLabel.pinLeading(to: contentView, constant: 10)
        ageLabel.pinTopToBottom(to: nameLabel, constant: 10)
        ageLabel.pinLeading(to: contentView, constant: 10)
        
    }
    
    func configure(name: String, age: Int) {
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14)
        ]
        
        let nameAttributedText = NSMutableAttributedString(string: "Name: ", attributes: boldAttributes)
        nameAttributedText.append(NSAttributedString(string: name, attributes: regularAttributes))
        
        let ageAttributedText = NSMutableAttributedString(string: "Age: ", attributes: boldAttributes)
        ageAttributedText.append(NSAttributedString(string: "\(age)", attributes: regularAttributes))
        
        nameLabel.attributedText = nameAttributedText
        ageLabel.attributedText = ageAttributedText
    }
}

// Colocar headers nas Settings:
//section 1 :  "User data"
//section 3 : "Links"

// Attributed text na celula nameAndAge --

// Adicionar error view controller nas Settings

// Usar estruturas de dados na criaçao do data source das Settings

// Usar didSelect da collectionView para abrir os links
