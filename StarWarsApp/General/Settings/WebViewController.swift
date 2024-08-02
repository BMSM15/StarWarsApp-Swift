//
//  WebViewController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 01/08/2024.
//


import UIKit
import WebKit

class WebViewController: UIViewController {
    private var webView: WKWebView!
    private var url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        webView = WKWebView()
        
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
