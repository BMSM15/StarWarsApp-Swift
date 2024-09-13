//
//  OnBoardingCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 20/08/2024.
//

import UIKit

class OnBoardingCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let pageControl = UIPageControl()
    private let nextButton: Button = Button()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(pageControl)
        contentView.addSubview(nextButton)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.pinTop(to: contentView)
        imageView.pinLeading(to: contentView, constant: 50)
        imageView.pinTrailing(to: contentView, constant: 50)
        
        titleLabel.pinTopToBottom(to: imageView, constant: 20)
        titleLabel.centerHorizontally(to: contentView)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        descriptionLabel.pinTopToBottom(to: titleLabel, constant: 10)
        descriptionLabel.pinLeading(to: contentView)
        descriptionLabel.pinTrailing(to: contentView)
        descriptionLabel.centerHorizontally(to: contentView)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .gray
    }
    
    func configure(with card: OnBoardingCard, pageIndex: Int, numberOfPages: Int, action: @escaping () -> Void) {
        imageView.image = UIImage(named: card.image)
        titleLabel.text = card.title
        descriptionLabel.text = card.text
    }
}
