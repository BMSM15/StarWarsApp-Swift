//
//  Buttonfactory.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 25/07/2024.
//

import UIKit

public typealias ButtonActionHandler = (UIButton) -> Void

class Button: UIButton {
    
    //MARK: - Variables
    
    var actionHandler: ButtonActionHandler?
    
    //MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup

    private func setup() {
        addTarget(self, action: #selector(buttonWasTapped), for: .touchUpInside)
    }
    
    func setupAsPrimaryButton() {
        backgroundColor = .black
        setTitleColor(.white, for: .normal)
        setTitleColor(.red, for: .highlighted)
    }
    
    func setupAsSecondaryButton() {
        backgroundColor = .red
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .highlighted)
    }
    
    @objc private func buttonWasTapped(_ sender: Button) {
        actionHandler?(self)
    }
}
