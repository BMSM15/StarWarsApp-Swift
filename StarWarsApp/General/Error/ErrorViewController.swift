//
//  ErrorViewController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 24/07/2024.
//

import UIKit

class ErrorViewController: UIViewController {
    private let errorLabel = UILabel()
    private let errorButton : Button
    private let backHomeButton : Button
    var retryButtonHandler: (() -> Void)?
    var goBackButtonHandler: (() -> Void)?
    //weak var delegate: ErrorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        errorView()
    }
    
    init() {
        self.errorButton = Button()
        self.backHomeButton = Button()
        super.init(nibName: nil, bundle: nil)
    }
    
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func errorView() {
        view.addSubview(errorLabel)
        view.addSubview(errorButton)
        view.addSubview(backHomeButton)
        errorLabel.text = "Error"
        errorButton.setTitle("Retry", for: .normal)
        backHomeButton.setTitle("Back Home", for: .normal)
        
        errorLabel.textAlignment = .center
        errorLabel.textColor = .red
        errorLabel.centerVertically(to: view)
        errorLabel.centerHorizontally(to: view)
        
        errorButton.setupAsPrimaryButton()
        errorButton.pinTop(to: errorLabel, constant: 50)
        errorButton.widthEqual(to: view, multiplier: 0.5)
        errorButton.centerHorizontally(to: view)
        
        backHomeButton.setupAsSecondaryButton()
        backHomeButton.pinTop(to: errorButton, constant: 50)
        backHomeButton.widthEqual(to: view, multiplier: 0.5)
        backHomeButton.centerHorizontally(to: view)
        //errorButton.addTarget(self, action: #selector (buttonclicked), for: .touchUpInside)
        errorButton.actionHandler = { [weak self] _ in
           self?.retryButtonHandler?()
        }
        backHomeButton.actionHandler = { [weak self] _ in
           self?.goBackButtonHandler?()
        }
    }
}
