//
//  UIView.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 05/08/2024.
//

import UIKit

public extension UIView {
    
    func usesAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    @discardableResult
    func pinTopByMultiplier(to view: UIView, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        usesAutoLayout()
        return topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: multiplier).activate()
    }

    func pin(to view: UIView, constant: CGFloat = 0) {
        pinTop(to: view, constant: 0)
        pinBottom(to: view, constant: 0)
        pinLeading(to: view, constant: 0)
        pinTrailing(to: view, constant: 0)
    }

    @discardableResult
    func pinTop(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return topAnchor.constraint(equalTo: view.topAnchor, constant: constant).activate()
    }

    @discardableResult
    func pinTopGreaterThanOrEqual(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: constant).activate()
    }

    @discardableResult
    func pinSafeAreaTop(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant).activate()
    }

    @discardableResult
    func pinBottom(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant).activate()
    }

    @discardableResult
    func pinBottomGreaterThanOrEqual(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -constant).activate()
    }

    @discardableResult
    func pinBottomLessThanOrEqual(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -constant).activate()
    }

    @discardableResult
    func pinSafeAreaBottom(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant).activate()
    }

    @discardableResult
    func pinLeading(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).activate()
    }

    @discardableResult
    func pinLeadingGreaterThanOrEqual(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: constant).activate()
    }

    @discardableResult
    func pinTrailing(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).activate()
    }

    @discardableResult
    func pinTrailingGreaterThanOrEqual(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -constant).activate()
    }
    
    @discardableResult
    func pinTrailingToLeadingGreaterThanOrEqual(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return trailingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor, constant: -constant).activate()
    }
    
    @discardableResult
    func height(constant: CGFloat) -> NSLayoutConstraint {
        usesAutoLayout()
        return heightAnchor.constraint(equalToConstant: constant).activate()
    }

    @discardableResult
    func width(constant: CGFloat) -> NSLayoutConstraint {
        usesAutoLayout()
        return widthAnchor.constraint(equalToConstant: constant).activate()
    }

    @discardableResult
    func widthEqual(to view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: constant).activate()
    }

    @discardableResult
    func widthLessThanOrEqual(to view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: multiplier, constant: constant).activate()
    }

    @discardableResult
    func widthEqualsToHeight(multiplier: CGFloat = 1) -> NSLayoutConstraint {
        usesAutoLayout()
        return widthAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier).activate()
    }

    @discardableResult
    func widthGreaterThanOrEqual(to constant: CGFloat) -> NSLayoutConstraint {
        usesAutoLayout()
        return widthAnchor.constraint(greaterThanOrEqualToConstant: constant).activate()
    }

    @discardableResult
    func widthLessThanOrEqual(to constant: CGFloat) -> NSLayoutConstraint {
        usesAutoLayout()
        return widthAnchor.constraint(lessThanOrEqualToConstant: constant).activate()
    }

    @discardableResult
    func heightEqual(to view: UIView, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        usesAutoLayout()
        return heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).activate()
    }

    @discardableResult
    func heightLessThanOrEqual(to view: UIView, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        usesAutoLayout()
        return heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: multiplier).activate()
    }

    @discardableResult
    func heightLessThanOrEqual(to constant: CGFloat) -> NSLayoutConstraint {
        usesAutoLayout()
        return heightAnchor.constraint(lessThanOrEqualToConstant: constant).activate()
    }

    @discardableResult
    func heightGreaterThanOrEqual(to constant: CGFloat) -> NSLayoutConstraint {
        usesAutoLayout()
        return heightAnchor.constraint(greaterThanOrEqualToConstant: constant).activate()
    }

    @discardableResult
    func heightGreaterThanOrEqual(to view: UIView, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        usesAutoLayout()
        return heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor).activate()
    }

    @discardableResult
    func heightEqualsToWidth(multiplier: CGFloat = 1) -> NSLayoutConstraint {
        usesAutoLayout()
        return heightAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier).activate()
    }

    @discardableResult
    func centerHorizontally(to parentView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: constant).activate()
    }

    @discardableResult
    func centerVertically(to parentView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: constant).activate()
    }

    @discardableResult
    func pinLeadingToTrailing(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).activate()
    }
    
    @discardableResult
    func pinLeadingToTrailingGreaterThanOrEqualTo(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return leadingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: constant).activate()
    }

    @discardableResult
    func pinTrailingToLeading(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -constant).activate()
    }

    @discardableResult
    func pinTopToBottom(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).activate()
    }

    @discardableResult
    func pinTopToBottomGreaterThanOrEqual(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return topAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: constant).activate()
    }

    @discardableResult
    func pinTopToBottomLessThanOrEqual(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return topAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -constant).activate()
    }

    @discardableResult
    func pinTopToSafeAreaBottom(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant).activate()
    }

    @discardableResult
    func pinBottomToTop(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return bottomAnchor.constraint(equalTo: view.topAnchor, constant: -constant).activate()
    }

    @discardableResult
    func pinBottomToTopLessThanOrEqual(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return bottomAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: -constant).activate()
    }

    @discardableResult
    func pinBottomToTopGreaterThanOrEqual(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return bottomAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: constant).activate()
    }

    // MARK: - Layout Guide

    @discardableResult
    func pinTopLayoutGuide(to layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: constant).activate()
    }

    @discardableResult
    func pinBottomLayoutGuide(to layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -constant).activate()
    }
}

extension NSLayoutConstraint {

    @discardableResult
    func activate() -> Self {
        isActive = true
        return self
    }

    @discardableResult
    func deactive() -> Self {
        isActive = false
        return self
    }
}
