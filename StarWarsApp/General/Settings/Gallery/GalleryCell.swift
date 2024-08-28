//
//  GalleryCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 12/08/2024.
//

import Foundation
import UIKit

class GalleryCell: UICollectionViewCell {
    
    private let imageView = ImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancel()
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
    
    func configure(with imageURL: URL, width: Int, height: Int) {
        imageView.setImage(url: imageURL)
        
        let aspectRatio = CGFloat(height) / CGFloat(width)
        let itemWidth = contentView.frame.width
        let itemHeight = itemWidth * aspectRatio
        
        imageView.height(constant: itemHeight)
    }

}

class ImageView: UIImageView {
    
    var task: URLSessionDataTask?
    var imageURL: URL?
    
    func setImage(url imageURL: URL, placeholder: UIImage? = nil) {
        self.imageURL = imageURL
        image = placeholder
        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let image = UIImage(data: data) {
                    if self?.imageURL == imageURL {
                        self?.image = image
                    } else {
                        print("🛑 Image does not match!")
                    }
                } else {
                    print("🛑 Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
        task.resume()
    }
    
    func cancel() {
        task?.cancel()
        task = nil
        image = nil
    }
}


