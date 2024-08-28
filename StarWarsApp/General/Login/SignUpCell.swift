//
//  SignUpCell.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 22/08/2024.
//

import UIKit

class SignUpCell: UICollectionViewCell {
    
    let nameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let birthdatePicker = UIDatePicker()
    let actionButton: Button = Button()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(nameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(birthdatePicker)
        contentView.addSubview(actionButton)
        contentView.addSubview(imageView)
        
        birthdatePicker.datePickerMode = .date
        actionButton.setTitle("Sign Up", for: .normal)
        
        nameTextField.setPadding(10)
        nameTextField.placeholder = "Name"
        nameTextField.setPlaceholderTextColor(.white)
        
        emailTextField.setPadding(10)
        emailTextField.placeholder = "Email"
        emailTextField.setPlaceholderTextColor(.white)
        
        passwordTextField.setPadding(10)
        passwordTextField.placeholder = "Password"
        passwordTextField.setPlaceholderTextColor(.white)
        
        
        imageView.contentMode = .scaleAspectFit
        imageView.pinTop(to: contentView)
        imageView.pinBottom(to: contentView, constant: 400)
        imageView.pinLeading(to: contentView, constant: 90)
        imageView.pinTrailing(to: contentView, constant: 90)
    
        nameTextField.centerHorizontally(to: contentView)
        nameTextField.pinTopToBottom(to: imageView)
        nameTextField.pinTrailing(to: contentView, constant: 50)
        nameTextField.pinLeading(to: contentView, constant: 50)
        nameTextField.backgroundColor = .gray
        nameTextField.height(constant: 40)
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.masksToBounds = true
        
        
        birthdatePicker.centerHorizontally(to: contentView)
        birthdatePicker.pinTopToBottom(to: nameTextField, constant: 30)
        birthdatePicker.pinTrailing(to: contentView, constant: 50)
        birthdatePicker.pinLeading(to: contentView, constant: 50)
        birthdatePicker.backgroundColor = .gray
        birthdatePicker.height(constant: 40)
        birthdatePicker.layer.cornerRadius = 10
        birthdatePicker.layer.masksToBounds = true
        
        emailTextField.centerHorizontally(to: contentView)
        emailTextField.pinTopToBottom(to: birthdatePicker, constant: 30)
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

