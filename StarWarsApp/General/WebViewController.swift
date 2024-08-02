import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    let viewModel: WebViewModel
    
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
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: viewModel.url)
        webView.load(myRequest)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("webview did fail load with error: \(error)")

        let message: String = error.localizedDescription

        let alert = UIAlertController(title: "something", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
        // use action here
        })
        self.present(alert, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        presentErrorViewController()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        presentErrorViewController()
    }
    
    private func presentErrorViewController() {
        let errorVC = ErrorViewController()
        navigationController?.pushViewController(errorVC, animated: true)
    }
}
