//
//  SettingsViewController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 30/07/2024.
//
// SettingsViewController.swift
import UIKit

class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel

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
        title = "Settings"
    }
}
