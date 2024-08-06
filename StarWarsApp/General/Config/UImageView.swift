//
//  UImageView.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 06/08/2024.
//

import UIKit

public extension UIImageView {
    func setImageURL(_ url: String) {
        setImageURL(URL(string: url))
    }
    
    func setImageURL(_ url: URL?) {
        guard let url = url else {
            self.image = nil
            return
        }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
    func load(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
