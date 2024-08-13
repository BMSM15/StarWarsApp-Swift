//
//  GalleryCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 12/08/2024.
//

import Foundation
import UIKit

class GalleryCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var imageURL: URL?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupViews() {
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.pin(to: contentView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func configure(with imageURL: URL) {
        imageView.image = nil
        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            } else {
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
}


