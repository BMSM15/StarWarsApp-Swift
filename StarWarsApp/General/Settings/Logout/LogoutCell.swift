//
//  LogoutCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 13/09/2024.
//

import UIKit

class LogoutCell: UICollectionViewCell {
    let containerView = UIView()
    let logoutButton = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.text = "Logout"
        logoutButton.textAlignment = .center
        logoutButton.backgroundColor = .red
        logoutButton.textColor = .white
        logoutButton.layer.masksToBounds = true
        logoutButton.layer.cornerRadius = 10
        
        contentView.addSubview(containerView)
        containerView.addSubview(logoutButton)
        containerView.pin(to: contentView)
        logoutButton.pin(to: contentView)
    }
}
