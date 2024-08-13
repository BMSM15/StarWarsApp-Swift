//
//  GalleryImageview.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 12/08/2024.
//

import UIKit

class GalleryImageViewController: UIViewController {
    
    // MARK: - Variables
    
    var imageView = UIImageView()
    var imageURL: URL?
    var pageIndex: Int = 0
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        imageView.image = nil
        super.viewDidLoad()
        imageView.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
        if let imageURL = imageURL {
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
}
