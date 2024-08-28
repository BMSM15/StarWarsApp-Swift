//
//  LoginCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 21/08/2024.
//

import UIKit

class LoginCell: UICollectionViewCell {
    
    let actionButton: Button = Button()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(actionButton)
        contentView.addSubview(imageView)
        
        actionButton.setTitle("Login", for: .normal)
        
        emailTextField.setPadding(10)
        emailTextField.placeholder = "Email"
        emailTextField.setPlaceholderTextColor(.white)
        
        passwordTextField.setPadding(10)
        passwordTextField.placeholder = "Password"
        passwordTextField.setPlaceholderTextColor(.white)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.pinTop(to: contentView)
        imageView.pinLeading(to: contentView, constant: 50)
        imageView.pinTrailing(to: contentView, constant: 50)
        
        emailTextField.centerHorizontally(to: contentView)
        emailTextField.pinTopToBottom(to: imageView)
        emailTextField.pinTrailing(to: contentView, constant: 50)
        emailTextField.pinLeading(to: contentView, constant: 50)
        emailTextField.backgroundColor = .gray
        emailTextField.height(constant: 40)
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.masksToBounds = true
        emailTextField.autocapitalizationType = .none
        
        passwordTextField.pinTopToBottom(to: emailTextField, constant: 30)
        passwordTextField.pinTrailing(to: contentView, constant: 50)
        passwordTextField.pinLeading(to: contentView, constant: 50)
        passwordTextField.backgroundColor = .gray
        passwordTextField.height(constant: 40)
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.masksToBounds = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = .gray
        actionButton.pinTopToBottom(to: passwordTextField, constant: 30)
        actionButton.pinTrailing(to: contentView, constant: 150)
        actionButton.pinLeading(to: contentView, constant: 150)
        actionButton.layer.cornerRadius = 10
        actionButton.layer.masksToBounds = true
    }
    
    func configure(action: @escaping () -> Void) {
        imageView.image = UIImage(named: "SWIcon")
        actionButton.actionHandler = { _ in
            action()
        }
    }
}

extension UITextField {
    
    func setPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setPlaceholderTextColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: color])
    }
}

extension UIDatePicker {
    
    func setDefaultDate(_ date: Date, animated: Bool = true) {
        self.setDate(date, animated: animated)
    }
    
}



