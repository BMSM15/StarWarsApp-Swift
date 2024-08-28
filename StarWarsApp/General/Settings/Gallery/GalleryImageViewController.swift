//
//  GalleryImageview.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 12/08/2024.
//

import UIKit

class GalleryImageViewController: UIViewController {
    
    // MARK: - Variables
    
    var imageURL: URL?
    var pageIndex: Int = 0
    var imageWidth: Int = 0
    var imageHeight: Int = 0
    
    private let imageView = UIImageView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        loadImage()
    }
    
    private func loadImage() {
        guard let url = imageURL else { return }
        imageView.loadImage(from: url)
    }
}
