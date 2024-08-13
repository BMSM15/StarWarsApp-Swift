//
//  HeaderCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 09/08/2024.
//

import UIKit

class HeaderCell: UICollectionReusableView {
    let containerView = UIView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(containerView)
        
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with title: String) {
        label.text = title
    }
}
