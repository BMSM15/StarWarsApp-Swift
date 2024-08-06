//
//  TabBarController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 02/08/2024.
//


import UIKit
import WebKit

protocol WebViewControllerDelegate : AnyObject {
    func webViewControllerNeedsToGoBack(_ viewController: WebViewController)
}

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    let viewModel: WebViewModel
    weak var delegate: WebViewControllerDelegate?
    
    
    init(viewModel: WebViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: viewModel.url)
        webView.load(myRequest)
    }
    
    // Handle error when navigation fails
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        presentErrorViewController()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        presentErrorViewController()
    }
    
    // Present ErrorViewController when an error occursb
    private func presentErrorViewController() {
        let errorVC = ErrorViewController()
        errorVC.retryButtonHandler = { [weak self] in
            self?.reloadWebView()
            self?.removeErrorViewController()
        }
        errorVC.goBackButtonHandler = { [weak self] in
            guard let self = self else {
                return
            }
            self.delegate?.webViewControllerNeedsToGoBack(self)
        }
        add(errorVC)
    }

    private func reloadWebView() {
        let myRequest = URLRequest(url: viewModel.url)
        webView.load(myRequest)
    }

    private func removeErrorViewController() {
        children.forEach { childVC in
            if let errorVC = childVC as? ErrorViewController {
                remove(errorVC)
            }
        }
    }
}
