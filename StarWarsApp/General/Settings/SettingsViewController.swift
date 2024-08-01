import UIKit
import AVKit
import WebKit

class SettingsViewController: UIViewController, WKUIDelegate {
    private let viewModel: SettingsViewModel
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let profileImageView = UIImageView()
    private var playerItem: AVPlayerItem!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var playerObserver: NSKeyValueObservation!
    private let videoContainerView = UIView()
    var webView: WKWebView!
    
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
        setupViews()
        setupConstraints()
        setupWebView()
        updateUI()
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    private func setupWebView() {
        //        let myURL = URL(string:"https://www.apple.com")
        //        let myRequest = URLRequest(url: myURL!)
        //        webView.load(myRequest)
    }
    
    
    private func setupViews() {
        title = "Settings"
        
        view.addSubview(nameLabel)
        view.addSubview(ageLabel)
        view.addSubview(profileImageView)
        view.addSubview(videoContainerView)
        
        nameLabel.textAlignment = .left
        ageLabel.textAlignment = .left
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        videoContainerView.backgroundColor = .black
    }
    
    private func setupConstraints() {
        nameLabel.pinTop(to: profileImageView, constant: 200)
        nameLabel.pinLeading(to: view, constant: 10)
        
        ageLabel.pinTop(to: nameLabel, constant: 30)
        ageLabel.pinLeading(to: view, constant: 10)
        
        profileImageView.pinTopSafeArea(to: view, constant: 10)
        profileImageView.centerHorizontally(to: view)
        profileImageView.widthEqual(to: view, multiplier: 0.45)
        profileImageView.heightEqual(to: view, multiplier: 0.20)
        
        NSLayoutConstraint.activate([
            videoContainerView.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 20),
            videoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            videoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            videoContainerView.heightAnchor.constraint(equalTo: videoContainerView.widthAnchor, multiplier: 9.0/16.0)
        ])
        
        //        videoContainerView.pinTop(to: ageLabel, constant: 20)
        //        videoContainerView.pinLeading(to: view, constant: 10)
        //        videoContainerView.pinTrailing(to: view, constant: -10)
        //        videoContainerView.heightEqual(to: videoContainerView, multiplier: 9.0/16.0)
    }
    
    private func updateUI() {
        guard let user = viewModel.user else { return }
        
        nameLabel.text = "Name: \(user.name)"
        
        let age = viewModel.calculateAge(from: user.birthdate)
        ageLabel.text = "Age: \(age!)"
        
        if let imageUrl = URL(string: user.imageURL) {
            profileImageView.load(url: imageUrl)
        }
        
        if let videoUrl = URL(string: user.videoURL) {
            let asset = AVAsset(url: videoUrl)
            playerItem = AVPlayerItem(asset: asset)
            observePlayer(playerItem)
            player = AVPlayer(playerItem: playerItem)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = videoContainerView.bounds
            playerLayer.videoGravity = .resizeAspect
            videoContainerView.layer.addSublayer(playerLayer)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }
    
    private func observePlayer(_ playerItem: AVPlayerItem) {
        playerObserver = playerItem.observe(\AVPlayerItem.status) { [weak self] (playerItem, _) in
            if playerItem.status == .readyToPlay {
                self?.player.play()
                self?.player.isMuted = true
            }
        }
    }
    
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
        player.seek(to: .zero)
        player.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//    private func handleLinkTap(_ link: Links) {
//        guard let url = URL(string: link.url) else { return }
//        
//        switch link.openMode {
//        case .internal:
//            openInternalWebView(with: url)
//        case .modal:
//            openModalWebView(with: url)
//        case .external:
//            openExternalWebView(with: url)
//        }
//    }
//    
//    private func openInternalWebView(with url: URL) {
//        let webViewController = WebViewController(url: url)
//        navigationController?.pushViewController(webViewController, animated: true)
//    }
//    
//    private func openModalWebView(with url: URL) {
//        let webViewController = WebViewController(url: url)
//        let navController = UINavigationController(rootViewController: webViewController)
//        present(navController, animated: true, completion: nil)
//    }
//    
//    private func openExternalWebView(with url: URL) {
//        UIApplication.shared.open(url)
//    }
}

