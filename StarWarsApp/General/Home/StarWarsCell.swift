//
//  TabBarController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 17/07/2024.
//

import UIKit

class StarWarsCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    let nameLabel = UILabel()
    let genderLabel = UILabel()
    let nameInputLabel = UILabel()
    let genderInputLabel = UILabel()
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        genderLabel.text = ""
        nameInputLabel.text = ""
        genderInputLabel.text = ""
    }
    
    // MARK: - Setup

    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(genderLabel)
        contentView.addSubview(nameInputLabel)
        contentView.addSubview(genderInputLabel)
        
        nameLabel.textColor = .white
        genderLabel.textColor = .white
        nameInputLabel.textColor = .white
        genderInputLabel.textColor = .white

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .gray

        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        genderLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        genderLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        nameInputLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        genderInputLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameInputLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        genderInputLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        nameInputLabel.translatesAutoresizingMaskIntoConstraints = false
        genderInputLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.pinTop(to: contentView, constant: 10)
        nameLabel.pinLeading(to: contentView, constant: 10)

        nameInputLabel.centerVertically(to: nameLabel)
        nameInputLabel.pinLeadingToTrailing(to: nameLabel, constant: 5)
        nameInputLabel.pinTrailing(to: contentView, constant: 10)
        
        genderLabel.pinTopToBottom(to: nameLabel, constant: 10)
        genderLabel.pinLeading(to: contentView, constant: 10)
        genderLabel.pinBottom(to: contentView, constant: 10)
        
        genderInputLabel.centerVertically(to: genderLabel)
        genderInputLabel.pinLeadingToTrailing(to: genderLabel, constant: 5)
        genderInputLabel.pinTrailing(to: contentView, constant: 10)
        
    }

    func configure(with person: Person) {
        nameInputLabel.text = person.name
        genderInputLabel.text = person.gender
        nameLabel.text = "Name:"
        genderLabel.text = "Gender:"
    }
}
