//
//  SettingsViewController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 30/07/2024.
//
// SettingsViewController.swift
import UIKit
import AVKit

class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let profileImageView = UIImageView()
    private var videoView : AVPlayer? = nil
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    private func setupViews() {
        title = "Settings"
        
        view.addSubview(nameLabel)
        view.addSubview(ageLabel)
        view.addSubview(profileImageView)
        
        nameLabel.textAlignment = .left
        ageLabel.textAlignment = .left
        
        
    }
    
}
